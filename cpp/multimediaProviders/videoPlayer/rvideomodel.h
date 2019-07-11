/* $Id: rvideomodel.h
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

#ifndef RVIDEOMODEL_H
#define RVIDEOMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QCoreApplication>
#include <QSqlDatabase>
#include <QDir>

#include "../cachecreatorthread.h"
#include "../querymodel.h"


class RVideoModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QueryModel* PQmodel READ PQmodel NOTIFY PQmodelChanged)
    Q_PROPERTY(int VideoCount READ VideoCount NOTIFY VideoCountChanged)
    Q_PROPERTY(QString CurrentVideoPath READ CurrentVideoPath NOTIFY CurrentVideoPathChanged)
    Q_PROPERTY(int ActiveIndex READ ActiveIndex WRITE setActiveIndex NOTIFY ActiveIndexChanged)

public:
    explicit RVideoModel(QObject *parent = nullptr);

    QueryModel *PQmodel() const{ return pqModel;}

    int VideoCount() const{ return pqModel->rowCount();}

    QString CurrentVideoPath() const{ return currentVideoPath;}

    int ActiveIndex() const{ return activeIndex;}
    void setActiveIndex(const int ActiveIndex);

    ~RVideoModel(){
        if(ccThread->isRunning())
            ccThread->wait();
        ccThread->terminate();
    }

signals:
    void PQmodelChanged();
    void VideoCountChanged();
    void CurrentVideoPathChanged();
    void ActiveIndexChanged();

public slots:
    void updateCacheDatabase();
    void updatePQmodelFromCache();

private:
    CacheCreatorThread *ccThread;
    QueryModel *pqModel;
    QString cachePath;
    QString currentVideoPath;
    int activeIndex;
};

#endif // RVIDEOMODEL_H
