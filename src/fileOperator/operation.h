#ifndef OPERATION_H
#define OPERATION_H

#include <QObject>
#include <QThread>
#include <QUrl>
#include <QFileInfo>
#include <QDir>
#include <QElapsedTimer>

class Operation : public QThread
{
    Q_OBJECT
public:
    Operation();

signals:
    void setHeader(const QString &);
    void setProgress(int );
    void setTimeRequired(const QString &);
    void setTransferSpeed(const QString &);

protected:
    qint64 getTheOverallFileSize(QFileInfo file);
    QString getFormattedFileSize(qint64 fileSize);
    QString getTimeRequired(qint64);

    QList<QUrl> fileList;
    QString destinitionPath;
    QElapsedTimer elaspedTime;
};

#endif // OPERATION_H
