#ifndef OPERATIONINDICATOR_H
#define OPERATIONINDICATOR_H

#include <QObject>
#include "rfileoperator.h"

class OperationIndicator: public QObject{
    Q_OBJECT

    Q_PROPERTY(QString Header READ Header NOTIFY HeaderChanged)
    Q_PROPERTY(int Progress READ Progress NOTIFY ProgressChanged)
    //Q_PROPERTY(QString StatusReport READ StatusReport NOTIFY StatusReportChanged)
    Q_PROPERTY(QString TimeRequired READ TimeRequired NOTIFY TimeRequiredChanged)
    Q_PROPERTY(QString TransferSpeed READ TransferSpeed NOTIFY TransferSpeedChanged)

public:
    OperationIndicator(QObject *parent = nullptr)
        :QObject (parent){}

    QString Header() const{return header;}
    void setHeader(const QString &Header){
        if(header != Header){
            header = Header;
            emit HeaderChanged();
        }
    }

    int Progress() const{return progress;}
    void setProgress(int Progress){
        if(progress != Progress){
            progress = Progress;
            emit ProgressChanged();
        }
    }

    OperationState StatusReport() const{ return statusReport;}
    void setStatusReport(const OperationState StatusReport){
        if(statusReport != StatusReport){
            statusReport = StatusReport;
            emit StatusReportChanged();
        }
    }

    QString TimeRequired() const{ return timeRequired;}
    void setTimeRequired(const QString &TimeRequired){
        if(timeRequired != TimeRequired){
            timeRequired = TimeRequired;
            emit TimeRequiredChanged();
        }
    }

    QString TransferSpeed() const{ return transferSpeed;}
    void setTransferSpeed(const QString &TransferSpeed){
        if(transferSpeed != TransferSpeed){
            transferSpeed = TransferSpeed;
            emit TransferSpeedChanged();
        }
    }

signals:
    void HeaderChanged();
    void ProgressChanged();
    void StatusReportChanged();
    void TimeRequiredChanged();
    void TransferSpeedChanged();

private:
    QString header;
    int progress;
    OperationState statusReport;
    QString timeRequired;
    QString transferSpeed;
};

#endif // OPERATIONINDICATOR_H


/*class QmlHelper : public QObject{
    Q_OBJECT

public:
    QmlHelper(QObject *parent = nullptr)
        :QObject (parent){}

signals:
    void setHeader(const QString &);
    void setProgress(const int);
    void setTimeRequired(const QString &);
    void setTransferSpeed(const QString &);

public slots:
    void getHeader(const QString &Header){
        emit setHeader(Header);
    }
};*/
