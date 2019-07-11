/* $Id: cachecreatorthread.cpp
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

#include "cachecreatorthread.h"


void CacheCreatorThread::excavateDirectory(QFileInfo file){
    QDir dir(file.filePath());

    dir.setFilter(QDir::NoDotAndDotDot | QDir::Dirs);
    foreach(QFileInfo file, dir.entryInfoList())
        excavateDirectory(file);

    dir.setFilter(QDir::NoDotAndDotDot | QDir::Files);
    dir.setNameFilters(extensionsToLookFor);
    foreach(QFileInfo file, dir.entryInfoList()){
        QString str = "INSERT OR REPLACE INTO " + cacheName + "List(Path, TimeCreated, LastUpdated) VALUES('" +
                file.filePath() + "', " +
                QString::number(file.birthTime().toSecsSinceEpoch()) + ", " +
                QString::number(QDateTime::currentSecsSinceEpoch()) + ")";
        QSqlQuery query(str, sqlDb);
        if(!query.isActive())
            qDebug() << "Failed: " << str;
    }
}
