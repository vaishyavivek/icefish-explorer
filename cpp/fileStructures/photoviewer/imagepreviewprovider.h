#ifndef IMAGEPREVIEWPROVIDER_H
#define IMAGEPREVIEWPROVIDER_H

#include <QQuickImageProvider>

class ImagePreviewProvider : public QQuickImageProvider
{
public:
    ImagePreviewProvider():
        QQuickImageProvider(QQuickImageProvider::Image){}

    QImage requestImage(const QString &filePath, QSize *size, const QSize &requestedSize) override{

        QImage image(filePath);
        if(size->isEmpty())
            *size = image.size();

        if(!requestedSize.isEmpty() && (size->height() > requestedSize.height() || size->width() > requestedSize.width()))
            return image.scaled(requestedSize, Qt::KeepAspectRatio);
        else
            return image;
    }
};

#endif // IMAGEPREVIEWPROVIDER_H
