/* $Id: trashinfomodel.cpp
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

#include "trashinfomodel.h"

void TrashInfoModel::recover(){
    QFile fileToRecover(currentPath);
    QString fileInfoName = currentPath;
    fileInfoName = fileInfoName.replace("files", "info");
    fileInfoName.append(".trashinfo");

    QFile fileInfo(fileInfoName);
    if(fileInfo.exists()){
        fileInfo.open(QIODevice::ReadOnly);
        QTextStream stream(&fileInfo);

        QString lines = stream.readLine();
        lines = stream.readLine();
        lines = lines.right(lines.length() - 5);

        QFile verify(lines);
        if(!verify.exists()){
            if(!fileToRecover.rename(lines))
                emit notify(Error::NoPermission);
            else{
                fileInfo.close();
                fileInfo.remove();
                emit removeDelegate();
            }
        }
        else
            emit notify(Error::FileAlreadyExist);
    }
    else
        emit notify(Error::PathDoesntExist);
}


void TrashInfoModel::remove(){

    QFile file(currentPath);
    if(file.remove()){
        QFile trashInfo(currentPath + ".trashinfo");
        if(!trashInfo.remove())
            emit notify(Error::RemovalFailed);
        else
            emit removeDelegate();
    }
    else
        emit notify(Error::RemovalFailed);
}
