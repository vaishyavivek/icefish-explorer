/* $Id: mimeinfoprovider.h
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

#ifndef MIMEINFOPROVIDER_H
#define MIMEINFOPROVIDER_H

#include <QObject>
#include <QThread>
#include <QMimeDatabase>
#include <QMimeType>

class MimeExtractorThread: public QObject{
    Q_OBJECT

public:
    MimeExtractorThread(QObject *parent = nullptr)
        :QObject(parent){}

public slots:
    void findInfo(QString Path){
        QMimeDatabase mimeDb;
        QMimeType mime = mimeDb.mimeTypeForFile(Path);
        emit getMimeShortInfo(mime.iconName());
    }

signals:
    void getMimeShortInfo(QString);
    void getMimeDescription(QString);
};


class MimeInfoProvider: public QObject{
    Q_OBJECT
    Q_PROPERTY(QString FilePath READ FilePath WRITE setFilePath NOTIFY FilePathChanged)
    Q_PROPERTY(QString MimeShortInfo READ MimeShortInfo NOTIFY MimeShortInfoChanged)
    Q_PROPERTY(QString MimeDescription READ MimeDescription NOTIFY MimeDescriptionChanged)

public:
    MimeInfoProvider(QObject *parent = nullptr)
        :QObject(parent){
    }

    QString MimeShortInfo() const{ return mimeShortInfo;}
    QString MimeDescription() const{ return mimeDescription;}

    QString FilePath() const{ return filePath;}
    void setFilePath(const QString &FilePath){
        //filePath = FilePath;
        QThread thread;
        MimeExtractorThread met;
        met.moveToThread(&thread);
        connect(&met, &MimeExtractorThread::getMimeShortInfo, this, &MimeInfoProvider::setMimeShortInfo);
        connect(this, &MimeInfoProvider::startThread, &met, &MimeExtractorThread::findInfo);
        thread.start();
        emit startThread(FilePath);
    }

signals:
    void startThread(QString);
    void FilePathChanged();
    void MimeShortInfoChanged();
    void MimeDescriptionChanged();

public slots:
    void setMimeShortInfo(QString MimeShortInfo){
        mimeShortInfo = MimeShortInfo;
        emit MimeShortInfoChanged();
    }
    void setMimeDescription(QString MimeDescription){
        mimeDescription = MimeDescription;
        emit MimeDescriptionChanged();
    }

private:
    QString filePath, mimeShortInfo, mimeDescription;
};

Q_DECLARE_METATYPE(MimeInfoProvider*)

#endif // MIMEINFOPROVIDER_H
