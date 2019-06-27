#ifndef RPHOTOMODEL_H
#define RPHOTOMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QCoreApplication>
#include <QSqlDatabase>
#include <QDir>

#include "cachecreatorthread.h"
#include "photoquerymodel.h"


class RPhotoModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(PhotoQueryModel* PQmodel READ PQmodel NOTIFY PQmodelChanged)
    Q_PROPERTY(QString CurrentImagePath READ CurrentImagePath NOTIFY CurrentImagePathChanged)
    Q_PROPERTY(int ActiveIndex READ ActiveIndex WRITE setActiveIndex NOTIFY ActiveIndexChanged)

public:
    explicit RPhotoModel(QObject *parent = nullptr);

    PhotoQueryModel *PQmodel() const{ return pqModel;}

    QString CurrentImagePath() const{ return currentImagePath;}

    int ActiveIndex() const{ return activeIndex;}
    void setActiveIndex(const int ActiveIndex);

signals:
    void PQmodelChanged();
    void CurrentImagePathChanged();
    void ActiveIndexChanged();

public slots:
    void updateCacheDatabase();
    void updatePQmodelFromCache();

    void saveEditingChangesInCurrentFile();
    void saveEditingChangesAsNewFile(QString filePath);

    void rotateImage(int rightOrLeft);

private:
    //CacheCreatorThread ccThread;
    PhotoQueryModel *pqModel;
    QString cachePath;
    QString currentImagePath;
    int activeIndex;
    //QSqlDatabase sqlDb;
};

#endif // RPHOTOMODEL_H
