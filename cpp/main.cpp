/* $Id: main.cpp
 * IceFish Explorer is a free File Manager for Linux Desktops for managing
 * local files as well as files on cloud, Dropbox, Onedrive, Googledrive.
 * Additionally, it also serves as a multimedia explorer for your photos,
 * music, videos, documents and other files by providing built-in plugins
 * to open them.
 * © IceFish Community, 2019
 *
 * This file is part of IceFish Explorer.
 *
 * IceFish Explorer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * IceFish Explorer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with IceFish Explorer.
 * If not, see <http://www.gnu.org/licenses/>.
 *
 * The project is hosted here,
 * http://www.icefish.tech/index/explorer/0-5
*/

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>

#include "rfilesystemmodel.h"
#include "fileOperations/rfileoperator.h"
#include "multimediaProviders/videoPlayer/rvideodetailsmodel.h"
#include "qmlImageProviders/mimeiconprovider.h"
#include "qmlImageProviders/pixmappreviewprovider.h"
#include "qmlImageProviders/mimeinfoprovider.h"
#include "qmlImageProviders/xdgiconprovider.h"
#include "models/dialogbox/rdialogbox.h"

/* count number of lines of codes
 * find . -name '*.*' | xargs wc -l
 */

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);


    /* Set the application credentials, to be used by dekstop environments for naming the window
     * QSettings also uses this to store and retrieve app settings such App Theme etc
     */
    QCoreApplication::setApplicationName("IceFish Explorer");
    QCoreApplication::setOrganizationDomain("icefishdevs.com");
    QCoreApplication::setOrganizationName("IceFish Devs");


    QGuiApplication app(argc, argv);
    //set the application icon, themed icon is not used since windows doesn't allow themed icons
    app.setWindowIcon(QIcon(":/local/assets/explorer-icefish.png"));

    qmlRegisterType<MimeInfoProvider>("com.mimeinfoprovider", 1, 0, "MimeInfoProvider");

    //qmlRegisterType<RDirectoryModel>("com.rdirectorymodel", 1, 0, "RDirectoryModel");

    qmlRegisterType<RDialogBox>("com.rdialogbox", 1, 0, "RDialogBox");

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


    RFileOperator *rfop = new RFileOperator(engine);
    ctxt->setContextProperty("rFileOperator", rfop);

    PathSetter *ps = new PathSetter(engine);
    ctxt->setContextProperty("mediaObj", ps);


    /* Image Providers for QML
     * "mime": Obtains the icon from current theme (only X11 platforms, no windows yet) for a mime type obtained from filePath
     * "preview": If preview is enabled then it returns the preview for image mime types (works on windows) else themed icon
     */
    engine->addImageProvider("mime", new MimeIconProvider());
    engine->addImageProvider("preview", new PixmapPreviewProvider());
    engine->addImageProvider("xdg", new XDGIconProvider());

    //loads the main.qml in ApplicationWindow
    engine->load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if(argc > 1){
        QString currentAddress = argv[1];
        rfsm->createNewTab(currentAddress);
    }

    if (engine->rootObjects().isEmpty())
        return -1;

    return app.exec();
}


/* TODO LIST
 ************* 1- desktop services************done
 ************* 2- properties ----------designed----------linking left
 ************* 3- linking with global properties************done
 ************* 4- allowing file operations***********50% work done
 ************* 5- adding dbus support**** uncertain whether to implement or not
 ************* 6- adding path to theme the app************done
 ************* 7- recents****************done
 ************* 8- gridview*****************done
 * 9- google-drive integration
 * 10- dropbox integration
 * 11- on-the-fly encreption for cloud data
*/
