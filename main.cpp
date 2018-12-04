#include <QGuiApplication>
//#include <QQuickStyle>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>

#include "HeaderFiles/rfilesystemmodel.h"
#include "HeaderFiles/rdesktopservices.h"
#include "HeaderFiles/mimeiconprovider.h"
#include "HeaderFiles/pixmappreviewprovider.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    /* Set the application credentials, to be used by dekstop environments for naming the window
     * QSettings also uses this to store and retrieve app settings such App Theme etc
     */
    QCoreApplication::setApplicationName("reverse-explorer");
    QCoreApplication::setOrganizationDomain("geetasoftwarecompany.com");
    QCoreApplication::setOrganizationName("Geeta Software Company");


    QGuiApplication app(argc, argv);
    //set the application icon, themed icon is not used since windows doesn't allow themed icons
    app.setWindowIcon(QIcon(":/local/Resources/explorer-colored.png"));

    QQmlApplicationEngine *engine = new QQmlApplicationEngine();

    QQmlContext *ctxt = engine->rootContext();

    /* "rFileSystem" is the qml accessor of the c++ code
     * only application level stuffs are accessed through this, like App Settings, request to create new tab or delete one,
     * open bookmark/trash Panel Popup
     * Otherwise each tab has its own property accessor named as "qtModel" which allows accessing properties of current directory opened in tab
     * Each tabs can also access properties of "rFileSystem" as its global.
     */
    RFileSystemModel *rfsm = new RFileSystemModel(engine);
    ctxt->setContextProperty("rFileSystem", rfsm);


    /* Class was designed to be used for providing desktop services like getting themed icon, filetype from meme database etc
     * But now its not used anymore for that purpose,
     * there're still some use cases for this, which will be replaced with more of generic Qt libraries
     *
     * It still serves the purpose of retrieving desktop service handler apps, like VLC opens mp4, Firefox opens http/s request
     * I assume this is still not complete, because of its slow handling time hence requires further work
     */
    RDesktopServices rds;
    rds.startMimeCaching();
    ctxt->setContextProperty("rDesktopService", &rds);


    /* Image Providers for QML
     * "mime": Obtains the icon from current theme (only X11 platforms, no windows yet) for a mime type obtained from filePath
     * "preview": If preview is enabled then it returns the preview for image mime types (works on windows) else themed icon
     */
    engine->addImageProvider("mime", new MimeIconProvider());
    engine->addImageProvider("preview", new PixmapPreviewProvider());

    //loads the main.qml in ApplicationWindow
    engine->load(QUrl(QStringLiteral("qrc:/QML/main.qml")));

    if (engine->rootObjects().isEmpty())
        return -1;

    return app.exec();
}


/* TODO LIST
 ************* 1- desktop services************done
 ************* 2- properties ----------designed----------linking left
 ************* 3- linking with global properties************done
 * 4- allowing file operations
 * 5- adding dbus support
 ************* 6- adding path to theme the app************done
 ************* 7- recents****************done
 * 8- gridview
 * 9- google-drive integration
 * 10- dropbox integration
 * 11- on-the-fly encreption for cloud data
*/
