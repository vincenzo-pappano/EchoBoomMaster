#pragma once

#include <QImage>
#include <QMutex>
#include <QQuickPaintedItem>

#include <gst/gst.h>
#include <gst/app/gstappsink.h>

class GstVideoItem : public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(int udpPort READ udpPort WRITE setUdpPort NOTIFY udpPortChanged)
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)

public:
    explicit GstVideoItem(QQuickItem *parent = nullptr);
    ~GstVideoItem() override;

    void paint(QPainter *painter) override;

    int udpPort() const;
    void setUdpPort(int port);

    bool running() const;

    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();

signals:
    void udpPortChanged();
    void runningChanged();

private:
    static GstFlowReturn onNewSample(GstAppSink *sink, gpointer userData);
    GstFlowReturn handleNewSample(GstAppSink *sink);

    void setRunning(bool value);
    QString buildPipelineDescription() const;
    void clearFrame();

private:
    mutable QMutex m_mutex;
    QImage m_frame;

    int m_udpPort = 5600;
    bool m_running = false;

    GstElement *m_pipeline = nullptr;
    GstElement *m_appSink = nullptr;
};
