#include <QDebug>
#include <QMetaObject>
#include <QPainter>

#include "GstVideoItem.h"

GstVideoItem::GstVideoItem(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setRenderTarget(QQuickPaintedItem::FramebufferObject);
}

GstVideoItem::~GstVideoItem()
{
    stop();
}

int GstVideoItem::udpPort() const
{
    return m_udpPort;
}

void GstVideoItem::setUdpPort(int port)
{
    if (m_udpPort == port) {
        return;
    }

    m_udpPort = port;
    emit udpPortChanged();
}

bool GstVideoItem::running() const
{
    return m_running;
}

void GstVideoItem::setRunning(bool value)
{
    if (m_running == value) {
        return;
    }

    m_running = value;
    emit runningChanged();
}

QString GstVideoItem::buildPipelineDescription() const
{
    // return QString(
    //     "udpsrc port=%1 "
    //     "caps=\"application/x-rtp, media=video, encoding-name=H264, payload=96\" "
    //     "! rtph264depay "
    //     "! h264parse "
    //     "! avdec_h264 "
    //     "! videoconvert "
    //     "! video/x-raw,format=BGRA "
    //     "! appsink name=videosink emit-signals=true sync=false max-buffers=1 drop=true"
    // ).arg(m_udpPort);
    return QString(
               "udpsrc port=%1 "
               "caps=\"application/x-rtp, media=video, encoding-name=H264, payload=96\" "
               "! rtph264depay "
               "! h264parse "
               "! avdec_h264 "
               "! videoconvert "
               "! video/x-raw,format=BGRA "
               "! appsink name=videosink emit-signals=true sync=false max-buffers=1 drop=true"
               ).arg(m_udpPort);
}


void GstVideoItem::start()
{
    if (m_pipeline) {
        return;
    }

    GError *error = nullptr;
    const QByteArray pipelineText = buildPipelineDescription().toUtf8();

    qDebug() << "Starting GStreamer pipeline:";
    qDebug().noquote() << pipelineText;

    m_pipeline = gst_parse_launch(pipelineText.constData(), &error);

    if (!m_pipeline) {
        qWarning() << "Failed to create GStreamer pipeline:"
                   << (error ? error->message : "unknown error");

        if (error) {
            g_error_free(error);
        }

        return;
    }

    if (error) {
        qWarning() << "GStreamer warning:" << error->message;
        g_error_free(error);
    }

    m_appSink = gst_bin_get_by_name(GST_BIN(m_pipeline), "videosink");

    if (!m_appSink) {
        qWarning() << "Could not find appsink named videosink";
        gst_object_unref(m_pipeline);
        m_pipeline = nullptr;
        return;
    }

    g_signal_connect(
        m_appSink,
        "new-sample",
        G_CALLBACK(GstVideoItem::onNewSample),
        this
        );

    const GstStateChangeReturn result =
        gst_element_set_state(m_pipeline, GST_STATE_PLAYING);

    if (result == GST_STATE_CHANGE_FAILURE) {
        qWarning() << "Failed to start GStreamer pipeline";

        gst_object_unref(m_appSink);
        m_appSink = nullptr;

        gst_object_unref(m_pipeline);
        m_pipeline = nullptr;

        return;
    }

    setRunning(true);
}

// void GstVideoItem::stop()
// {
//     if (!m_pipeline) {
//         return;
//     }

//     gst_element_set_state(m_pipeline, GST_STATE_NULL);

//     if (m_appSink) {
//         gst_object_unref(m_appSink);
//         m_appSink = nullptr;
//     }

//     gst_object_unref(m_pipeline);
//     m_pipeline = nullptr;

//     setRunning(false);
// }

void GstVideoItem::stop()
{
    if (!m_pipeline) {
        clearFrame();
        setRunning(false);
        return;
    }

    gst_element_set_state(m_pipeline, GST_STATE_NULL);

    if (m_appSink) {
        gst_object_unref(m_appSink);
        m_appSink = nullptr;
    }

    gst_object_unref(m_pipeline);
    m_pipeline = nullptr;

    clearFrame();
    setRunning(false);
}

GstFlowReturn GstVideoItem::onNewSample(GstAppSink *sink, gpointer userData)
{
    auto *self = static_cast<GstVideoItem *>(userData);
    return self->handleNewSample(sink);
}

GstFlowReturn GstVideoItem::handleNewSample(GstAppSink *sink)
{
    GstSample *sample = gst_app_sink_pull_sample(sink);

    if (!sample) {
        return GST_FLOW_ERROR;
    }

    GstCaps *caps = gst_sample_get_caps(sample);
    GstBuffer *buffer = gst_sample_get_buffer(sample);

    if (!caps || !buffer) {
        gst_sample_unref(sample);
        return GST_FLOW_ERROR;
    }

    GstStructure *structure = gst_caps_get_structure(caps, 0);

    int width = 0;
    int height = 0;

    gst_structure_get_int(structure, "width", &width);
    gst_structure_get_int(structure, "height", &height);

    if (width <= 0 || height <= 0) {
        gst_sample_unref(sample);
        return GST_FLOW_ERROR;
    }

    GstMapInfo mapInfo;

    if (!gst_buffer_map(buffer, &mapInfo, GST_MAP_READ)) {
        gst_sample_unref(sample);
        return GST_FLOW_ERROR;
    }

    const int bytesPerPixel = 4;
    const int expectedBytes = width * height * bytesPerPixel;

    if (static_cast<int>(mapInfo.size) >= expectedBytes) {
        QImage image(
            mapInfo.data,
            width,
            height,
            width * bytesPerPixel,
            QImage::Format_ARGB32
            );

        {
            QMutexLocker locker(&m_mutex);
            m_frame = image.copy();
        }

        QMetaObject::invokeMethod(
            this,
            "update",
            Qt::QueuedConnection
            );
    }

    gst_buffer_unmap(buffer, &mapInfo);
    gst_sample_unref(sample);

    return GST_FLOW_OK;
}

void GstVideoItem::paint(QPainter *painter)
{
    painter->fillRect(boundingRect(), Qt::black);

    QImage frameCopy;

    {
        QMutexLocker locker(&m_mutex);
        frameCopy = m_frame;
    }

    if (frameCopy.isNull()) {
        painter->setPen(Qt::white);
        painter->drawText(
            boundingRect(),
            Qt::AlignCenter,
            "Waiting for live stream ..."
            );
        return;
    }

    painter->drawImage(
        boundingRect(),
        frameCopy,
        frameCopy.rect()
        );
}

void GstVideoItem::clearFrame()
{
    {
        QMutexLocker locker(&m_mutex);
        m_frame = QImage();
    }

    update();
}
