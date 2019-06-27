#include "rphotomodel.h"
#include <QDebug>
#include <QSqlRecord>
#include <QImage>
#include <QMatrix>

RPhotoModel::RPhotoModel(QObject *parent) : QObject(parent){
    const QString DRIVER("QSQLITE");
    if(!QSqlDatabase::isDriverAvailable(DRIVER))
        qDebug() << "No Suitable SqLite Driver was found, Aborting now.";

    pqModel = new PhotoQueryModel();

    cachePath = QDir::homePath() + "/.config/" + QCoreApplication::organizationName();
    QDir::setCurrent(cachePath);
    updatePQmodelFromCache();
    QSqlDatabase::removeDatabase(QSqlDatabase::database("QSQLITE").databaseName());
    updateCacheDatabase();
}

void RPhotoModel::updateCacheDatabase(){
    ccThread = new CacheCreatorThread();
    connect(ccThread, &CacheCreatorThread::cacheCreationCompleted, this, &RPhotoModel::updatePQmodelFromCache);
    connect(ccThread, &CacheCreatorThread::finished, ccThread, &QObject::deleteLater);
    ccThread->start();
}

void RPhotoModel::updatePQmodelFromCache(){
    QSqlDatabase sqlDb = QSqlDatabase::addDatabase("QSQLITE");
    sqlDb.setDatabaseName("icefishGxCache.sqlite");
    if(!sqlDb.open())
        qDebug() << "Failed to open database file, Aborting now" << sqlDb.lastError().text();

    pqModel->setQuery("SELECT * FROM PhotosList", sqlDb);
    emit PQmodelChanged();
    activeIndex = -1;
}


void RPhotoModel::setActiveIndex(const int ActiveIndex){
    if(activeIndex != ActiveIndex && ActiveIndex < pqModel->rowCount() && ActiveIndex > -1){
        QVariant var = pqModel->record(ActiveIndex).value("Path");
        currentImagePath = var.toString();
        emit CurrentImagePathChanged();
        activeIndex = ActiveIndex;
        emit ActiveIndexChanged();
    }
}

void RPhotoModel::saveEditingChangesInCurrentFile(){
    QImage image(currentImagePath);
    QVariant var = pqModel->record(activeIndex).value("Path");
    currentImagePath = var.toString();
    image.save(currentImagePath);
    emit CurrentImagePathChanged();
}

void RPhotoModel::saveEditingChangesAsNewFile(QString filePath){
    QImage image(currentImagePath);
    currentImagePath = filePath;
    image.save(currentImagePath);
    emit CurrentImagePathChanged();
}


void RPhotoModel::rotateImage(int rightOrLeft){
    QImage image(currentImagePath);
    QMatrix mat;
    mat.rotate(90*rightOrLeft);
    image = image.transformed(mat);
    image.save(cachePath + "/currentImage.png");
    currentImagePath = cachePath + "/currentImage1.png";
    emit CurrentImagePathChanged();
    currentImagePath = cachePath + "/currentImage.png";
    emit CurrentImagePathChanged();
}
