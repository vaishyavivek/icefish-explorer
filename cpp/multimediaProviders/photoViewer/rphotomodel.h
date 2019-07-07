#ifndef RPHOTOMODEL_H
#define RPHOTOMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QCoreApplication>
#include <QSqlDatabase>
#include <QDir>

#include "../cachecreatorthread.h"
#include "../querymodel.h"


class RPhotoModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QueryModel* PQmodel READ PQmodel NOTIFY PQmodelChanged)
    Q_PROPERTY(int PhotoCount READ PhotoCount NOTIFY PhotoCountChanged)
    Q_PROPERTY(QString CurrentImagePath READ CurrentImagePath NOTIFY CurrentImagePathChanged)
    Q_PROPERTY(int ActiveIndex READ ActiveIndex WRITE setActiveIndex NOTIFY ActiveIndexChanged)

public:
    explicit RPhotoModel(QObject *parent = nullptr);

    QueryModel *PQmodel() const{ return pqModel;}

    int PhotoCount() const{ return pqModel->rowCount();}

    QString CurrentImagePath() const{ return currentImagePath;}

    int ActiveIndex() const{ return activeIndex;}
    void setActiveIndex(const int ActiveIndex);

    ~RPhotoModel(){
        if(ccThread->isRunning())
            ccThread->wait();
        ccThread->terminate();
    }

signals:
    void PQmodelChanged();
    void PhotoCountChanged();
    void CurrentImagePathChanged();
    void ActiveIndexChanged();

public slots:
    void updateCacheDatabase();
    void updatePQmodelFromCache();

    void saveEditingChangesInCurrentFile();
    void saveEditingChangesAsNewFile(QString filePath);

    void rotateImage(int rightOrLeft);

private:
    CacheCreatorThread *ccThread;
    QueryModel *pqModel;
    QString cachePath;
    QString currentImagePath;
    int activeIndex;
    //QSqlDatabase sqlDb;
};

#endif // RPHOTOMODEL_H
