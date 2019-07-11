/* $Id: rphotomodel.cpp
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

#include "rphotomodel.h"
#include <QDebug>
#include <QSqlRecord>
#include <QImage>
#include <QMatrix>

RPhotoModel::RPhotoModel(QObject *parent) : QObject(parent){
    /*const QString DRIVER("QSQLITE");
    if(!QSqlDatabase::isDriverAvailable(DRIVER))
        qDebug() << "No Suitable SqLite Driver was found, Aborting now.";*/

    pqModel = new QueryModel();

    cachePath = QDir::homePath() + "/.config/" + QCoreApplication::organizationName();
    QDir::setCurrent(cachePath);

    updatePQmodelFromCache();

    updateCacheDatabase();
}

void RPhotoModel::updateCacheDatabase(){
    QStringList extensionsToLookFor;
    extensionsToLookFor.append("*.jpg");
    extensionsToLookFor.append("*.jpeg");
    extensionsToLookFor.append("*.png");
    extensionsToLookFor.append("*.gif");
    extensionsToLookFor.append("*.svg");

    QStringList pathsToLookInto;
    pathsToLookInto.append(QDir::homePath());

    ccThread = new CacheCreatorThread("Photos", extensionsToLookFor, pathsToLookInto);
    connect(ccThread, &CacheCreatorThread::cacheCreationCompleted, this, &RPhotoModel::updatePQmodelFromCache);
    connect(ccThread, &CacheCreatorThread::finished, ccThread, &QObject::deleteLater);
    ccThread->start();
}

void RPhotoModel::updatePQmodelFromCache(){
    QSqlDatabase sqlDb = QSqlDatabase::database("mainThread");

    sqlDb.setDatabaseName("icefishPhotosCache.sqlite");
    if(!sqlDb.open())
        qDebug() << "Failed to open database file, Aborting now" << sqlDb.lastError().text();

    pqModel->setQuery("SELECT * FROM PhotosList", sqlDb);
    emit PQmodelChanged();
    sqlDb.close();
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
