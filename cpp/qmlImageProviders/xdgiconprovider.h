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
