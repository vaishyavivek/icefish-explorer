/* $Id: cachecreatorthread.h
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

#ifndef CACHECREATORTHREAD_H
#define CACHECREATORTHREAD_H

#include <QCoreApplication>
#include <QThread>
#include <QDir>
#include <QDateTime>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

class CacheCreatorThread : public QThread
{
    Q_OBJECT

public:
    CacheCreatorThread(QString CacheName, QStringList ExtensionsToLookFor, QStringList PathsToLookInto)
        :cacheName(CacheName), extensionsToLookFor(ExtensionsToLookFor), pathsToLookInto(PathsToLookInto){}

    void run() override{
        cachePath = QDir::homePath() + "/.config/" + QCoreApplication::organizationName();
        QDir::setCurrent(cachePath);
        //cachePath = QDir::currentPath();

        const QString DRIVER("QSQLITE");
        if(!QSqlDatabase::isDriverAvailable(DRIVER)){
            qDebug() << "No Suitable SqLite Driver was found, Aborting now.";
            QThread::terminate();
        }

        sqlDb = QSqlDatabase::addDatabase("QSQLITE", cacheName + "Thread");

        sqlDb.setDatabaseName("icefish" + cacheName + "Cache.sqlite");

        if(!sqlDb.open()){
            qDebug() << "Failed to open database file, Aborting now" << sqlDb.lastError().text();
            QThread::terminate();
            QThread::wait();
        }
        else{
            QSqlQuery query("CREATE TABLE IF NOT EXISTS " + cacheName + "List(Path TEXT PRIMARY KEY, TimeCreated INTEGER, LastUpdated INTEGER)", sqlDb);
            if(!query.isActive())
                qDebug() << "Failed to create database table" << query.lastError().text() << ", Aborting now";

            foreach(QString anotherPath, pathsToLookInto)
                excavateDirectory(QFileInfo(QDir::homePath()));
            sqlDb.close();
        }

        sqlDb.commit();
        QSqlDatabase::removeDatabase(cacheName + "Thread");
        emit cacheCreationCompleted();
    }

signals:
    void cacheCreationCompleted();

private:
    void excavateDirectory(QFileInfo);

    QString cacheName;
    QString cachePath;
    QStringList extensionsToLookFor;
    QList<QString> pathsToLookInto;
    QSqlDatabase sqlDb;
};

#endif // CACHECREATORTHREAD_H
