#include "rvideomodel.h"
#include <QDebug>
#include <QSqlRecord>
#include <QImage>
#include <QMatrix>

RVideoModel::RVideoModel(QObject *parent) : QObject(parent){
    /*const QString DRIVER("QSQLITE");
    if(!QSqlDatabase::isDriverAvailable(DRIVER))
        qDebug() << "No Suitable SqLite Driver was found, Aborting now.";*/

    pqModel = new QueryModel();

    cachePath = QDir::homePath() + "/.config/" + QCoreApplication::organizationName();
    QDir::setCurrent(cachePath);

    updatePQmodelFromCache();

    updateCacheDatabase();
}

void RVideoModel::updateCacheDatabase(){
    QStringList extensionsToLookFor;
    extensionsToLookFor.append("*.mp4");
    extensionsToLookFor.append("*.avi");

    QStringList pathsToLookInto;
    pathsToLookInto.append(QDir::homePath());
    pathsToLookInto.append("/mnt/data/");

    ccThread = new CacheCreatorThread("Video", extensionsToLookFor, pathsToLookInto);
    connect(ccThread, &CacheCreatorThread::cacheCreationCompleted, this, &RVideoModel::updatePQmodelFromCache);
    connect(ccThread, &CacheCreatorThread::finished, ccThread, &QObject::deleteLater);
    ccThread->start();
}

void RVideoModel::updatePQmodelFromCache(){
    QSqlDatabase sqlDb = QSqlDatabase::database("mainThread");

    sqlDb.setDatabaseName("icefishVideoCache.sqlite");
    if(!sqlDb.open())
        qDebug() << "Failed to open database file, Aborting now" << sqlDb.lastError().text();

    pqModel->setQuery("SELECT * FROM VideoList", sqlDb);
    emit PQmodelChanged();
    sqlDb.close();
    activeIndex = -1;
}


void RVideoModel::setActiveIndex(const int ActiveIndex){
    if(activeIndex != ActiveIndex && ActiveIndex < pqModel->rowCount() && ActiveIndex > -1){
        QVariant var = pqModel->record(ActiveIndex).value("Path");
        currentVideoPath = var.toString();
        emit CurrentVideoPathChanged();
        activeIndex = ActiveIndex;
        emit ActiveIndexChanged();
    }
}

