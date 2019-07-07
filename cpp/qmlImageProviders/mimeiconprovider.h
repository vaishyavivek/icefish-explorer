/*This file is part of IceFish Explorer.

    IceFish Explorer is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    IceFish Explorer is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with IceFish Explorer. If not, see <http://www.gnu.org/licenses/>.
*/
#ifndef MIMEICONEPROVIDER_H
#define MIMEICONPROVIDER_H

#include <QQuickImageProvider>
#include <QPixmap>
#include <QIcon>
#include <QMimeDatabase>
#include <QMimeType>

class MimeIconProvider: public QQuickImageProvider{
    //Q_OBJECT
public:
    MimeIconProvider()
        :QQuickImageProvider(QQuickImageProvider::Pixmap){}

    QPixmap requestPixmap(const QString &filePath, QSize *size, const QSize &requestedSize) override{
        if(size)
            *size = QSize(32, 32);

        if(filePath == "Directory" || filePath == "folder"){

            //look for an icon in the system icon db
            QIcon folderIcon = QIcon::fromTheme("folder");
            if(!folderIcon.isNull())
                return folderIcon.pixmap(requestedSize);

            //if no icon is present then return the papirus icon
            return QPixmap(":/local/assets/papirus-icons/places/folder.svg").scaled(requestedSize);
        }

        QMimeDatabase mimeDb;
        QMimeType mime = mimeDb.mimeTypeForFile("file." + filePath, QMimeDatabase::MatchExtension);
        QString iconName = mime.iconName();

        //check if the system icon db has a relevant icon
        if(!QIcon::hasThemeIcon(iconName)){
            //if no icon is present then check if local icon db has one
            QPixmap localIcon(":/local/assets/papirus-icons/mimetypes/" + mime.iconName() + ".svg");
            if(!localIcon.isNull())
                localIcon.scaled(requestedSize);

            //even if local db doesn't have it, what can we do
            return QPixmap(":/local/assets/file.svg").scaled(requestedSize);
        }

        //system db has an icon, return it
        QIcon icon = QIcon::fromTheme(iconName);
        QPixmap pixmap = icon.pixmap(requestedSize);
        return pixmap;
    }
};

#endif // MIMEICONPROVIDER_H
