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

    void run() override{
        pathsToLookInto.append(QDir::homePath());
        fileTypes.append("*.jpg");
        fileTypes.append("*.jpeg");
        fileTypes.append("*.png");
        fileTypes.append("*.gif");
        fileTypes.append("*.svg");

        //cachePath = QDir::homePath() + "/.config/" + QCoreApplication::organizationName();
        //QDir::setCurrent(cachePath);
        cachePath = QDir::currentPath();

        const QString DRIVER("QSQLITE");
        if(!QSqlDatabase::isDriverAvailable(DRIVER)){
            qDebug() << "No Suitable SqLite Driver was found, Aborting now.";
            QThread::terminate();
        }

        QSqlDatabase sqlDb(QSqlDatabase::addDatabase("QSQLITE"));
        sqlDb.setDatabaseName("icefishGxCache.sqlite");
        if(!sqlDb.open())
            qDebug() << "Failed to open database file, Aborting now" << sqlDb.lastError().text();
        else{
            QSqlQuery query("CREATE TABLE IF NOT EXISTS PhotosList(Path TEXT PRIMARY KEY, TimeCreated INTEGER, LastUpdated INTEGER)");
            if(!query.isActive())
                qDebug() << "Failed to create database table" << query.lastError().text() << ", Aborting now";

            foreach(QString anotherPath, pathsToLookInto)
                excavateDirectory(QFileInfo(QDir::homePath()));
            sqlDb.close();
        }

        //QSqlDatabase::removeDatabase("threadCon");
        emit cacheCreationCompleted();
    }

signals:
    void cacheCreationCompleted();

private:
    void excavateDirectory(QFileInfo);

    QList<QString> pathsToLookInto;
    QList<QString> fileTypes;
    QString cachePath;
    //QSqlDatabase sqlDb;
};

#endif // CACHECREATORTHREAD_H
