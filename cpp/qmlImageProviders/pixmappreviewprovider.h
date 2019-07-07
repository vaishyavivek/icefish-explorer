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
#ifndef PIXMAPPREVIEWPROVIDER_H
#define PIXMAPPREVIEWPROVIDER_H

#include <QQuickImageProvider>
#include <QPixmap>
#include <QIcon>
#include <QMimeDatabase>
#include <QMimeType>
#include <QDebug>

class PixmapPreviewProvider: public QQuickImageProvider{
public:
    PixmapPreviewProvider()
        :QQuickImageProvider(QQuickImageProvider::Pixmap){}

    QPixmap requestPixmap(const QString &filePath, QSize *size, const QSize &requestedSize) override{
        if(size)
            *size = QSize(32, 32);

        QMimeDatabase mimeDb;
        QMimeType mime = mimeDb.mimeTypeForFile(filePath);

        if(mime.iconName().contains("image"))
            return  QPixmap(filePath).scaled(requestedSize, Qt::KeepAspectRatio);

        QIcon icon = QIcon::fromTheme(mime.iconName());
        QPixmap pixmap = icon.pixmap(requestedSize);
        return pixmap;
    }
};

#endif // PIXMAPPREVIEWPROVIDER_H
