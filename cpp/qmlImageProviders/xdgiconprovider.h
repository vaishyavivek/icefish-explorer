/* $Id: xdgiconprovider.h
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

#ifndef XDGICONPROVIDER_H
#define XDGICONPROVIDER_H

#include <QQuickImageProvider>
#include <QPixmap>
#include <QIcon>

class XDGIconProvider: public QQuickImageProvider{
    //Q_OBJECT
public:
    XDGIconProvider()
        :QQuickImageProvider(QQuickImageProvider::Pixmap){}

    QPixmap requestPixmap(const QString &xdgName, QSize *size, const QSize &requestedSize) override{
        if(size)
            *size = QSize(32, 32);

        if(!QIcon::hasThemeIcon(xdgName)){
            //check if the icon is present in the app local db
            QPixmap pixmap(":/local/assets/papirus-icons/places/" + xdgName +".svg");
            if(!pixmap.isNull())
                return pixmap.scaled(requestedSize);

            //return a generic icon if nothing is present
            return QPixmap(":/local/assets/generic.png");
        }

        //look for an icon in the system icon theme if it is found
        QIcon icon = QIcon::fromTheme(xdgName);
        QPixmap pixmap = icon.pixmap(requestedSize);
        return pixmap;
    }
};

#endif // XDGICONPROVIDER_H
