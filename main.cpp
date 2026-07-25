#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>
#include <QUrl>
#include <QDir>


#include "FixedAspectRatioWindow.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));

    qputenv("QML_XHR_ALLOW_FILE_READ", "1");

    qmlRegisterType<FixedAspectRatioWindow>(
        "CustomWindow",
        1,
        0,
        "FixedAspectRatioWindow");

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
    qDebug() << "appRootUrl: " << appRootUrl << Qt::endl;
    engine.rootContext()->setContextProperty("appRootUrl", appRootUrl);

    engine.load(url);

    return QGuiApplication::exec();
}
