/* $Id: cloudaccountviewer.cpp
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

#include "cloudaccountviewer.h"
#include <QDebug>

CloudAccountViewer::CloudAccountViewer(QObject *parent)
    : QObject(parent){
    usedSpace = 0;
    allocatedSpace = 1;
}

void CloudAccountViewer::setSpaceUsage(){
    double spaceUsed = usedSpace, spaceAllowed = allocatedSpace;
    QString usedStr = "  Bytes", allowedStr = "  Bytes";
    char byteRanges[] = {'K', 'M', 'G', 'T'};


    for(int i = 0; spaceUsed > 1023; i++){
        spaceUsed = spaceUsed/1023;
        usedStr[1] = byteRanges[i];
    }

    for(int i = 0; spaceAllowed > 1023; i++){
        spaceAllowed = spaceAllowed/1023;
        allowedStr[1] = byteRanges[i];
    }

    spaceUsage = "<b>" + QString::number(spaceUsed,'f', 2) + usedStr + "</b> Used of <b>" + QString::number(spaceAllowed,'f', 2) + allowedStr + "</b>";
    emit SpaceUsageChanged();
}
