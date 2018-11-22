#include "HeaderFiles/rdesktopservices.h"

#include <QFile>
#include <QDir>
#include <QMimeType>
#include <QDebug>
#include <QIcon>
#include <QImage>
#include <QThread>

RDesktopServices::RDesktopServices(QObject *parent) :
    QObject(parent){
    QDir cacheDir(QDir::homePath() + "/.cache/reverse-files");
    if(!cacheDir.exists())
        if(!cacheDir.mkpath(cacheDir.path()))
            qDebug() << "Failed to access cache directory.";

    cacheDir.setPath(QDir::homePath() + "/.cache/reverse-files/MimeDatabase");
    if(!cacheDir.exists())
        if(!cacheDir.mkdir(QDir::homePath() + "/.cache/reverse-files/MimeDatabase"))
                qDebug() << "Failed to access MIME Database, current session will run slow.";

    cacheDir.setPath(QDir::homePath() + "/.cache/reverse-files/IconCache");
    if(!cacheDir.exists())
        if(!cacheDir.mkdir(QDir::homePath() + "/.cache/reverse-files/IconCache"))
                qDebug() << "Failed to access MIME Database, current session will run slow.";
}


QString RDesktopServices::getThemeIcon(QString filePath, int scale){

    //qDebug() << QThread::currentThreadId();


    bool isStdMime = filePath.startsWith("std-name");
    filePath = isStdMime ? filePath.right(filePath.length() - filePath.indexOf(':') - 1) : filePath;

    QMimeType mime = mimeDb.mimeTypeForFile(filePath);
    emit provideFileType(mime.comment());

    QString stdFileType = isStdMime ? filePath : mime.iconName();

    QDir dir(QDir::homePath() + "/.cache/reverse-files/MimeDatabase");
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
    QFile settingFile(QDir::homePath() + "/.cache/reverse-files/globalsettings.rde");

    if(!settingFile.exists()){
        QFile localFile(":/local/Resources/globalSettings.rde");
        if(localFile.open(QIODevice::ReadOnly)){
            QFile file(QDir::homePath() + "/.cache/reverse-files/globalsettings.rde");
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
        QFile settingFile(QDir::homePath() + "/.cache/reverse-files/globalsettings.rde");

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
