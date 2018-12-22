#ifndef OPERATION_H
#define OPERATION_H

#include <QObject>
#include <QThread>
#include <QUrl>
#include <QFileInfo>
#include <QDir>
#include <QElapsedTimer>
#include "rfileoperator.h"

class Operation : public QThread
{
    Q_OBJECT
public:
    Operation();

signals:
    void setHeader(const QString &);
    void setProgress(int );
    void setStatusReport(RFileOperator::OperationState);
    void setTimeRequired(const QString &);
    void setTransferSpeed(const QString &);

protected:
    qint64 getTheOverallFileSize(QFileInfo file);
    QString getFormattedFileSize(qint64 fileSize);
    QString getTimeRequired(qint64);
    void saveTransferStates(QString opType);

    QList<QUrl> fileList;
    QString destinitionPath;
    QElapsedTimer elaspedTime;

    long long overAllCompleted = 0;
    int errored = 0;
    qint64 totalFileSize = 0;
    double transferSpeed = 0;
};

#endif // OPERATION_H
