#ifndef PHOTOLISTMODEL_H
#define PHOTOLISTMODEL_H

#include<QObject>

class PhotoListModel : public QObject{

    Q_OBJECT
    Q_PROPERTY(QList<QObject*> PhotoList READ PhotoList NOTIFY PhotoListChanged)
    Q_PROPERTY(QString ListName READ ListName NOTIFY ListNameChanged)
    Q_PROPERTY(int ListCount READ ListCount NOTIFY ListCountChanged)
    Q_PROPERTY(int ListIndex READ ListIndex NOTIFY ListIndexChanged)

public:
    PhotoListModel(QObject *parent = nullptr):QObject(parent){}
    PhotoListModel(QList<QObject*> &PhotoList, QString &ListName, int &ListIndex, QObject *parent = nullptr)
        : photoList(PhotoList), listName(ListName), listIndex(ListIndex), QObject(parent){}

    QList<QObject*> PhotoList() const{return photoList;}
    QString  ListName() const{return listName;}
    int ListCount() const{return  photoList.length();}
    int ListIndex() const{return listIndex;}

signals:
    void PhotoListChanged();
    void ListNameChanged();
    void ListCountChanged();
    void ListIndexChanged();

private:
    QList<QObject*> photoList;
    QString listName;
    int listIndex;
};

#endif // PHOTOLISTMODEL_H


#ifndef PHOTOINFOMODEL_H
#define PHOTOINFOMODEL_H

class PhotoInfoModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString ImagePath READ ImagePath NOTIFY ImagePathChanged)
public:
    explicit PhotoInfoModel(QObject *parent = nullptr);
    PhotoInfoModel(const QString &ImagePath, QObject *parent = nullptr)
        :imagePath(ImagePath), QObject(parent) {}

    QString ImagePath() const{return imagePath;}

signals:
    void ImagePathChanged();

private:
    QString imagePath;
};

#endif //PHOTOINFOMODEL_H
