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

        if(!QIcon::hasThemeIcon(xdgName))
            return QPixmap(":/local/assets/icons-folder.svg");

        QIcon icon = QIcon::fromTheme(xdgName);
        QPixmap pixmap = icon.pixmap(requestedSize);
        if(pixmap.isNull())
            return QPixmap(":/local/assets/icons-folder.svg");
        return pixmap;
    }
};

#endif // XDGICONPROVIDER_H
