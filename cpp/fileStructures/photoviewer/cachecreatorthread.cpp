#include "cachecreatorthread.h"


void CacheCreatorThread::excavateDirectory(QFileInfo file){
    QDir dir(file.filePath());

    dir.setFilter(QDir::NoDotAndDotDot | QDir::Dirs);
    foreach(QFileInfo file, dir.entryInfoList())
        excavateDirectory(file);

    dir.setFilter(QDir::NoDotAndDotDot | QDir::Files);
    dir.setNameFilters(fileTypes);
    foreach(QFileInfo file, dir.entryInfoList()){

        QString str = "INSERT OR REPLACE INTO PhotosList(Path, TimeCreated, LastUpdated) VALUES('" +
                file.filePath() + "', " +
                QString::number(file.birthTime().toSecsSinceEpoch()) + ", " +
                QString::number(QDateTime::currentSecsSinceEpoch()) + ")";
        QSqlQuery query(str);
        if(!query.isActive())
            qDebug() << "Failed: " << str;
    }
}
