#include <QGuiApplication>
//#include <QQuickStyle>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "HeaderFiles/rfilesystemmodel.h"
#include "HeaderFiles/rdesktopservices.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine *engine = new QQmlApplicationEngine();

    QQmlContext *ctxt = engine->rootContext();

    RFileSystemModel *rfsm = new RFileSystemModel(engine);
    ctxt->setContextProperty("rFileSystem", rfsm);

    RDesktopServices rds;
    rds.startMimeCaching();
    ctxt->setContextProperty("rDesktopService", &rds);

    engine->load(QUrl(QStringLiteral("qrc:/QML/main.qml")));

    if (engine->rootObjects().isEmpty())
        return -1;

    return app.exec();
}

/* TODO LIST
 ************* 1- desktop services************
 * 2- properties
 * 3- linking with global properties
 * 4- allowing file operations
 * 5- adding dbus support
 * 6- adding path to theme the app
*/
