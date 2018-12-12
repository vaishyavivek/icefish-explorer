#ifndef NAVIGATIONHISTORYMODEL_H
#define NAVIGATIONHISTORYMODEL_H

#include <QObject>

class NavigationHistoryModel: public QObject{

    Q_OBJECT
    Q_PROPERTY(QString Path READ Path WRITE setPath NOTIFY PathChanged)
    Q_PROPERTY(int ActiveIndex READ ActiveIndex WRITE setActiveIndex NOTIFY ActiveIndexChanged)

public:
    explicit NavigationHistoryModel(const QString &Path, QObject *parent = nullptr)
        :QObject(parent), path(Path){
        activeIndex = 0;
    }

    QString Path() const{ return path;}
    void setPath(const QString &Path){
        if(path != Path)
            path = Path;
    }

    int ActiveIndex() const{ return  activeIndex;}
    void setActiveIndex(const int ActiveIndex){
        if(activeIndex != ActiveIndex)
            activeIndex = ActiveIndex;
    }

signals:
    void PathChanged();
    void ActiveIndexChanged();

private:
    QString path;
    int activeIndex;
};

#endif // NAVIGATIONHISTORYMODEL_H
