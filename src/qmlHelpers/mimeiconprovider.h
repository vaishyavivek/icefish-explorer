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

        QMimeDatabase mimeDb;
        QMimeType mime = mimeDb.mimeTypeForFile(filePath);
        QString iconName = mime.iconName();

        if(!QIcon::hasThemeIcon(iconName)){
            if(iconName.contains("directory"))
                return QPixmap("/local/assets/icons-folder.svg");
            else
                return QPixmap("/local/assets/icons-file.svg");
        }

        QIcon icon = QIcon::fromTheme(iconName);
        QPixmap pixmap = icon.pixmap(requestedSize);
        return pixmap;
    }
};

#endif // MIMEICONPROVIDER_H
