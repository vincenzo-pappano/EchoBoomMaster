#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>
#include <QUrl>
#include <QDir>
#include <gst/gst.h>
#include <QLoggingCategory>
#include <QSysInfo>
#include <QMessageBox>
#include <QPushButton>

#include "logging/Logger.h"
#include "GstVideoItem.h"
#include "FixedAspectRatioWindow.h"
#include "logging/Logger.h"

Q_LOGGING_CATEGORY(appLog, "eb.app")
Q_LOGGING_CATEGORY(heavyLog, "eb.heavy")
#define qDebugHeavy() qCDebug(heavyLog)


static QString compilerDescription();
static QString buildType();
static void logStartupRecord();

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif


    QApplication app(argc, argv);

    QCoreApplication::setOrganizationName("Banergy");
    QCoreApplication::setOrganizationDomain("banergy.com");
    QCoreApplication::setApplicationName("EchoBoomMaster");
    QCoreApplication::setApplicationVersion(PROJECT_VERSION_STRING);

    Logger::configureFiltering();
    Logger *logger = Logger::self();

    if (!logger->isReady()) {
        QMessageBox messageBox;

        messageBox.setIcon(QMessageBox::Critical);
        messageBox.setWindowTitle(
            QStringLiteral("Logging Initialization Failed")
            );

        messageBox.setText(
            QStringLiteral(
                "EchoBoomMaster could not create its log file."
                )
            );

        messageBox.setInformativeText(
            QStringLiteral(
                "Attempted log file:\n%1\n\n"
                "Error:\n%2"
                )
                .arg(
                    QDir::toNativeSeparators(
                        logger->fileName()
                        ),
                    logger->errorString()
                    )
            );

        messageBox.setStandardButtons(
            QMessageBox::NoButton
            );

        QPushButton *continueButton =
            messageBox.addButton(
                QStringLiteral("Continue without logging"),
                QMessageBox::AcceptRole
                );

        QPushButton *exitButton =
            messageBox.addButton(
                QStringLiteral("Exit"),
                QMessageBox::RejectRole
                );

        messageBox.setDefaultButton(exitButton);
        messageBox.setEscapeButton(exitButton);

        messageBox.exec();

        if (messageBox.clickedButton() == exitButton) {
            return EXIT_FAILURE;
        }

        Q_UNUSED(continueButton)
    } else {
        Logger::installHandler();
    }

    gst_init(&argc, &argv);

    if (logger->isReady()) {
        logStartupRecord();
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

    const int exitCode = app.exec();

    if (logger->isReady()) {
        qCInfo(appLog)
        << "Application shutting down normally."
        << "Exit code:"
        << exitCode;

        Logger::uninstallHandler();
    }

    return exitCode;
}


static QString compilerDescription()
{
#if defined(__MINGW64__)
    return QStringLiteral("MinGW-w64 GCC %1")
        .arg(QString::fromLatin1(__VERSION__));
#elif defined(__MINGW32__)
    return QStringLiteral("MinGW GCC %1")
        .arg(QString::fromLatin1(__VERSION__));
#elif defined(_MSC_VER)
    return QStringLiteral("Microsoft Visual C++ %1")
        .arg(_MSC_VER);
#else
    return QStringLiteral("Unknown compiler");
#endif
}

static QString buildType()
{
#ifdef QT_DEBUG
    return QStringLiteral("Debug");
#else
    return QStringLiteral("Release");
#endif
}

static void logStartupRecord()
{
    const QString userName =
        qEnvironmentVariable("USERNAME",
                             QStringLiteral("unknown"));

    const QString hostName =
        QSysInfo::machineHostName().isEmpty()
            ? QStringLiteral("unknown")
            : QSysInfo::machineHostName();

    qCInfo(appLog).noquote()
        << "======================== Application startup ======================";

    qCInfo(appLog).noquote()
        << "Application:"
        << QCoreApplication::applicationName();

    qCInfo(appLog).noquote()
        << "Version:"
        << QCoreApplication::applicationVersion();

    qCInfo(appLog).noquote()
        << "Git commit:"
        << QStringLiteral(GIT_COMMIT_ID);

    qCInfo(appLog).noquote()
        << "Executable:"
        << QDir::toNativeSeparators(
               QCoreApplication::applicationFilePath());

    qCInfo(appLog).noquote()
        << "Log file:"
        << QDir::toNativeSeparators(
               Logger::self()->fileName());

    qCInfo(appLog).noquote()
        << "Windows user:"
        << userName;

    qCInfo(appLog).noquote()
        << "Computer name:"
        << hostName;

    qCInfo(appLog).noquote()
        << "Operating system:"
        << QSysInfo::prettyProductName();

    qCInfo(appLog).noquote()
        << "CPU architecture:"
        << QSysInfo::currentCpuArchitecture();

    qCInfo(appLog).noquote()
        << "Build architecture:"
        << QSysInfo::buildCpuArchitecture();

    qCInfo(appLog).noquote()
        << "Build ABI:"
        << QSysInfo::buildAbi();

    qCInfo(appLog).noquote()
        << "Build type:"
        << buildType();

    qCInfo(appLog).noquote()
        << "Compiler:"
        << compilerDescription();

    qCInfo(appLog).noquote()
        << "Qt version:"
        << qVersion();

    qCInfo(appLog).noquote()
        << "GStreamer version:"
        << QString::fromUtf8(gst_version_string());

    qCInfo(appLog).noquote()
        << "===================================================================";
}