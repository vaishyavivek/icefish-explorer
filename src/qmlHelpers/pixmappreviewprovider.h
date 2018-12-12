#ifndef PIXMAPPREVIEWPROVIDER_H
#define PIXMAPPREVIEWPROVIDER_H

#include <QQuickImageProvider>
#include <QPixmap>
#include <QIcon>
#include <QMimeDatabase>
#include <QMimeType>

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
