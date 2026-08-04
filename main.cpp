#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>
#include <QUrl>
#include <QDir>
#include <gst/gst.h>
#include "GstVideoItem.h"
#include "FixedAspectRatioWindow.h"
#include "logging/Logger.h"

Q_LOGGING_CATEGORY(appLog, "eb.appLog")

Q_LOGGING_CATEGORY(heavyLog, "eb.heavy")
#define qDebugHeavy() qCDebug(heavyLog)

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    gst_init(&argc, &argv);

    QApplication app(argc, argv);

    QCoreApplication::setOrganizationName("Banergy");
    QCoreApplication::setOrganizationDomain("banergy.com");
    QCoreApplication::setApplicationName("EchoBoomMaster");
    QCoreApplication::setApplicationVersion(PROJECT_VERSION_STRING);

    Logger::configureFiltering();
    Logger *logger = Logger::self();
    if (logger->isReady()) {
        Logger::installHandler();
    }

    qCInfo(appLog) << "Logger04 application category test";
    qCInfo(appLog) << "Logger04 second application message";
    qDebug() << "Logger04 default category test";
    qDebugHeavy() << "Logger04 heavy debug test";

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));

    qputenv("QML_XHR_ALLOW_FILE_READ", "1");

    qmlRegisterType<GstVideoItem>(
        "EchoBoom.Video",
        1,
        0,
        "GstVideoItem");

    qmlRegisterType<FixedAspectRatioWindow>(
        "CustomWindow",
        1,
        0,
        "FixedAspectRatioWindow");

    qDebug(appLog) << "Current Git Commit ID:" << GIT_COMMIT_ID;

    QQmlApplicationEngine engine;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    QString appRootUrl = QUrl::fromLocalFile(QDir::currentPath() + "/").toString();
    qDebug(appLog) << "appRootUrl: " << appRootUrl << Qt::endl;
    engine.rootContext()->setContextProperty("appRootUrl", appRootUrl);

    engine.rootContext()->setContextProperty("gitCommitId", QString(GIT_COMMIT_ID));

    const QString videoRootUrl =
        QUrl::fromLocalFile(
            QCoreApplication::applicationDirPath() + "/"
            ).toString();

    qDebug(appLog) << "videoRootUrl:" << videoRootUrl;

    engine.rootContext()->setContextProperty(
        "videoRootUrl",
        videoRootUrl
        );

    engine.load(url);

    return app.exec();
}
