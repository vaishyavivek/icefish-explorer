#include <QGuiApplication>
//#include <QQuickStyle>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>

#include "HeaderFiles/rfilesystemmodel.h"
#include "HeaderFiles/rdesktopservices.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/local/Resources/explorer-colored.png"));

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
 ************* 1- desktop services************done
 ************* 2- properties ----------designed----------linking left
 ************* 3- linking with global properties-----------designed-----------linkign left
 * 4- allowing file operations
 * 5- adding dbus support
 ************* 6- adding path to theme the app----------50% done
 * 7- recents
 * 8- gridview
*/
