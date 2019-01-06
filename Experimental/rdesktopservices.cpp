#include "rdesktopservices.h"
#include "models/desktopfilemodel.h"

#include <QFile>
#include <QDir>
#include <QMimeType>
#include <QDebug>
#include <QIcon>
#include <QImage>
#include <QThread>
#include <QProcess>

RDesktopServices::RDesktopServices(QObject *parent) :
    QObject(parent){
    QDir cacheDir(QDir::homePath() + "/.cache/reverse-explorer");
    if(!cacheDir.exists())
        if(!cacheDir.mkpath(cacheDir.path()))
            qDebug() << "Failed to access cache directory.";

    cacheDir.setPath(QDir::homePath() + "/.cache/reverse-explorer/MimeDatabase");
    if(!cacheDir.exists())
        if(!cacheDir.mkdir(QDir::homePath() + "/.cache/reverse-explorer/MimeDatabase"))
                qDebug() << "Failed to access MIME Database, current session will run slow.";

    cacheDir.setPath(QDir::homePath() + "/.cache/reverse-explorer/IconCache");
    if(!cacheDir.exists())
        if(!cacheDir.mkdir(QDir::homePath() + "/.cache/reverse-explorer/IconCache"))
                qDebug() << "Failed to access MIME Database, current session will run slow.";
}


QString RDesktopServices::getThemeIcon(QString filePath, int scale){

    //qDebug() << QThread::currentThreadId();


    bool isStdMime = filePath.startsWith("std-name");
    filePath = isStdMime ? filePath.right(filePath.length() - filePath.indexOf(':') - 1) : filePath;

    QMimeType mime = mimeDb.mimeTypeForFile(filePath);
    emit provideFileType(mime.comment());

    QString stdFileType = isStdMime ? filePath : mime.iconName();

    QDir dir(QDir::homePath() + "/.cache/reverse-explorer/MimeDatabase");
    QString mimeDir = dir.path() + "/" + QIcon::themeName() + "/" + QString::number(scale) + "/";
    QString iconPath = mimeDir + stdFileType + ".png";

    QFile file(iconPath);
    if(file.exists()){
        emit provideCachedIcon(iconPath);
        return iconPath;
    }

    dir.mkpath(mimeDir);

    QIcon icon = QIcon::fromTheme(stdFileType);
    QPixmap pixmap = icon.pixmap(scale, scale);

    if(pixmap.save(iconPath, "PNG")){
        emit provideCachedIcon(iconPath);
        return iconPath;
    }

    return ".";
}

QString RDesktopServices::constructCachedPreview(QString filePath, int scale){

    QMimeType mime = mimeDb.mimeTypeForFile(filePath);
    if(!mime.iconName().contains("image"))
        return "";

    if(filePath.contains(".thumbnails")){
        emit provideCachedPreview(filePath);
        return filePath;
    }

    QString cacheDirPath = filePath.left(filePath.lastIndexOf('/')) + "/.thumbnails/" + QString::number(scale);
    QString cacheFilePath = cacheDirPath + filePath.right(filePath.length() - filePath.lastIndexOf('/'));

    QFile cacheFile(cacheFilePath);
    if(cacheFile.exists()){
        emit provideCachedPreview(cacheFilePath);
        return cacheFilePath;
    }

    QDir cacheDir(cacheDirPath);
    if(!cacheDir.exists())
        cacheDir.mkpath(cacheDirPath);

    QImage image(filePath);
    if(image.isNull())
        return "";

    image = image.scaled(scale*2, scale*2, Qt::KeepAspectRatio);

    if(image.save(cacheFilePath)){
        emit provideCachedPreview(cacheFilePath);
        return cacheFilePath;
    }

    return cacheFilePath;
}

QString RDesktopServices::getSettingsValue(QString Name){
    QFile settingFile(QDir::homePath() + "/.cache/reverse-explorer/globalsettings.rde");

    if(!settingFile.exists()){
        QFile localFile(":/local/Resources/globalSettings.rde");
        if(localFile.open(QIODevice::ReadOnly)){
            QFile file(QDir::homePath() + "/.cache/reverse-explorer/globalsettings.rde");
            if(file.open(QIODevice::WriteOnly)){
                file.write(localFile.readAll());
                file.close();
                localFile.close();
            }
        }
    }

    if(settingFile.open(QIODevice::ReadOnly)){
        QString wholeFile(settingFile.readAll());
        int index = wholeFile.indexOf(Name);
        int nextNewLine = wholeFile.indexOf('\n', index);
        index = Name.length() + index + 1;
        QString value = wholeFile.mid(index, nextNewLine - index);
        return value;
    }
    return "";
}

void RDesktopServices::applySettingsValue(QString Name, QString Param){

    if(!Param.isEmpty()){
        QFile settingFile(QDir::homePath() + "/.cache/reverse-explorer/globalsettings.rde");

        if(settingFile.open(QIODevice::ReadOnly)){
            QByteArray wholeSetting = settingFile.readAll();

            int indexOfSettingValue = wholeSetting.indexOf(Name);
            int nextNewline = wholeSetting.indexOf('\n', indexOfSettingValue);
            nextNewline -= wholeSetting.indexOf('=', indexOfSettingValue);

            if(indexOfSettingValue > 0)
                wholeSetting.replace(indexOfSettingValue + Name.length() + 1,
                                     nextNewline, Param.toUtf8() + '\n');
            else
                wholeSetting.append(Name + "=" + Param + "\n");

            settingFile.close();
            if(settingFile.open(QIODevice::WriteOnly)){
                settingFile.write(wholeSetting);
                settingFile.close();
            }
        }
    }
}


void DesktopFileDataExtractor::run(){
    QFile file("/usr/share/applications/mimeinfo.cache");
    QString stream;

    if(file.open(QIODevice::ReadOnly)){
        //read the whole data from mimeInfo.cache and close the file
        stream = file.readAll();
        file.close();
        stream = stream.mid(stream.indexOf('\n'));


        //*mimeType doesn't exist (may be we're running for the first time or the app is newly installed)
        //if above case is true, then create the directory in RPI home
        //this is needed because Qfile doesn't create any parent dirs if they don't exist otherwise creates only the file
        QDir mimeDir(QDir::homePath() + "/.cache/reverse-explorer/mimeDB" );
        if(!mimeDir.exists())
            mimeDir.mkdir(QDir::homePath() + "/.cache/reverse-explorer/mimeDB");

        //each new line contains data about another mime type, so process them one by one
        QString lineFromMimeInfo;
        RDesktopServices rds;
        foreach (lineFromMimeInfo, stream.split('\n', QString::SkipEmptyParts)) {

            //open the current mimeInfo in form, video-3gp if it is in form video/3gp
            //this replacement is needed to prevent error - Qfile trying to create those dirs before '/' symbol
            QString temp = lineFromMimeInfo.left(lineFromMimeInfo.indexOf('='));
            QFile desktopFile(QDir::homePath() + "/.cache/reverse-explorer/mimeDB/" + temp.replace('/', '-'));

            //if the mimeinfo type already exist, then go for it else start over from mimeInfo.cache
            if(!desktopFile.exists()){

                //open this file for writing the new contents
                if(!desktopFile.open(QIODevice::WriteOnly))
                    qDebug() << "Failed to open" + desktopFile.fileName().toUtf8();

                //sample=== application/atom+xml=org.kde.akregator.desktop
                //contents after = is appList
                lineFromMimeInfo = lineFromMimeInfo.mid(lineFromMimeInfo.indexOf('=') + 1);

                QString desktopFileForApp;

                //each app is separated by ';'
                foreach (desktopFileForApp, lineFromMimeInfo.split(';', QString::SkipEmptyParts)) {

                    desktopFile.write(desktopFileForApp.toUtf8() + "|");

                    //open *.desktop file for this app
                    QFile modelFile("/usr/share/applications/" + desktopFileForApp);

                    if(modelFile.open(QIODevice::ReadOnly)){
                        desktopFileForApp = modelFile.readAll();

                        /* sample vlc.desktop file
                         * [Desktop Entry]
                            Version=1.0
                            Name=VLC media player
                            GenericName=Media player
                            Exec=/usr/bin/vlc --started-from-file %U
                            Icon=vlc
                            *
                            *
                            *
                         */

                        int nextIndex = desktopFileForApp.indexOf("Name=") + 5;
                        temp = desktopFileForApp.mid(nextIndex, desktopFileForApp.indexOf('\n', nextIndex) - nextIndex);
                        desktopFile.write(temp.toUtf8() + "|");

                        nextIndex = desktopFileForApp.indexOf("Exec") + 5;
                        temp = desktopFileForApp.mid(nextIndex, desktopFileForApp.indexOf('\n', nextIndex) - nextIndex);
                        desktopFile.write(temp.toUtf8() + "|");

                        nextIndex = desktopFileForApp.indexOf("Icon") + 5;
                        desktopFileForApp = desktopFileForApp.mid(nextIndex, desktopFileForApp.indexOf('\n', nextIndex) - nextIndex);
                        temp = rds.getThemeIcon("std-name:" + desktopFileForApp);
                        desktopFile.write(temp.toUtf8() + '\n');

                        modelFile.close();
                    }
                }
                desktopFile.close();
            }
        }
    }
}


void RDesktopServices::startMimeCaching(){
    DesktopFileDataExtractor *wThread = new DesktopFileDataExtractor();
    wThread->start();
}


QList<QObject*> RDesktopServices::getAssociatedServicesList(QString fileName){
    QList<QObject*> associatedServiceList;

    QMimeType mime = mimeDb.mimeTypeForFile(fileName);

    if(mime.iconName() == "application-x-sharedlib")
        return associatedServiceList;

    QFile associativeFile(QDir::homePath() + "/.cache/reverse-explorer/mimeDB/" + mime.iconName());

    if(associativeFile.exists() && associativeFile.open(QIODevice::ReadOnly)){
        QString wholeFile = associativeFile.readAll();
        QString service;
        foreach (service, wholeFile.split('\n', QString::SkipEmptyParts)) {
            QStringList dataList = service.split('|', QString::SkipEmptyParts);
            DesktopFileModel *newService = new DesktopFileModel();
            newService->setDesktopFile(dataList.at(0));
            newService->setServiceName(dataList.at(1));
            newService->setExecPath(dataList.at(2));
            newService->setServiceIcon("file://" + dataList.at(3));
            associatedServiceList.append(newService);
        }
    }

    DesktopFileModel *defaultService = new DesktopFileModel();
    defaultService->setDesktopFile("rdesktopservices.desktop");
    defaultService->setServiceName("Select another app...");
    defaultService->setServiceIcon("/local/Resources/not-found.svg");
    associatedServiceList.append(defaultService);

    return  associatedServiceList;
}


bool RDesktopServices::runDesktopService(QString filePath){
    QMimeType mime = mimeDb.mimeTypeForFile(filePath);

    if(mime.iconName() == "application-x-sharedlib"){
        QProcess::startDetached(filePath);
        return true;
    }

    QFile mimeFile(QDir::homePath() + "/.cache/reverse-explorer/mimeDB/" + mime.iconName());
    if(mimeFile.open(QIODevice::ReadOnly)){
        QString services = mimeFile.readAll();
        QStringList serviceList = services.split('\n', QString::SkipEmptyParts);

        for(int i = 0; i < serviceList.length(); i++){
            services = serviceList.at(i);
            services = services.split('|', QString::SkipEmptyParts).at(2);
            if(services.contains('%'))
                services = services.left(services.indexOf('%'));

            if(!QProcess::startDetached(services + "\"" + filePath + "\"")){
                QProcess::startDetached(services, QStringList() << filePath);
                break;
            }
        }
        mimeFile.close();
    }

    return  false;
}

bool RDesktopServices::runDesktopService(QString filePath, QString desktopFilePath){

    QFile desktopFile("/usr/share/applications/" + desktopFilePath);
    if(desktopFile.open(QIODevice::ReadOnly)){
        QString wholeFile = desktopFile.readAll();
        wholeFile = wholeFile.mid(wholeFile.indexOf("Exec=") + 5);
        wholeFile = wholeFile.left(wholeFile.indexOf('\n'));
        if(wholeFile.contains('%'))
            wholeFile = wholeFile.left(wholeFile.indexOf('%'));

        if(!QProcess::startDetached(wholeFile + "\"" + filePath + "\""))
            QProcess::startDetached(wholeFile, QStringList() << filePath);

        desktopFile.close();
        return true;
    }
    return false;
}
