#ifndef RFILEOPERATOR_H
#define RFILEOPERATOR_H

#include <QObject>

#include "operationindicator.h"

enum class OperationState{
    Ready,
    Running,
    Paused,
    Interrupted,
    Finished
};

class RFileOperator : public QObject
{
    Q_OBJECT

public:
    explicit RFileOperator(QObject *parent = nullptr);

signals:

public slots:
    void copyFiles(QString originalPath, QString destinationPath, QList<QObject*> fileList);
    void moveFiles(QString originalPath, QString destinationPath, QList<QObject*> fileList);
    void deleteFiles(QList<QObject*> fileList);
    void recoverFiles(QList<QObject*> fileList);

private:
    QList<QObject*> operationQueue;
};


#endif // RFILEOPERATOR_H
