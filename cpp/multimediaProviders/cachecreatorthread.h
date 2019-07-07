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
