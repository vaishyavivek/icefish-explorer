#ifndef OPERATIONINDICATOR_H
#define OPERATIONINDICATOR_H

#include <QObject>

class OperationIndicator: public QObject{
    Q_OBJECT
    Q_PROPERTY(QString Header READ Header WRITE setHeader NOTIFY HeaderChanged)
    Q_PROPERTY(int Progress READ Progress WRITE setProgress NOTIFY ProgressChanged)
    Q_PROPERTY(QString StatusReport READ StatusReport WRITE setStatusReport NOTIFY StatusReportChanged)
    Q_PROPERTY(QString TimeRequired READ TimeRequired WRITE setTimeRequired NOTIFY TimeRequiredChanged)
    Q_PROPERTY(QString TransferSpeed READ TransferSpeed WRITE setTransferSpeed NOTIFY TransferSpeedChanged)


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
    void setProgress(const int &Progress){
        if(progress != Progress){
            progress = Progress;
            emit ProgressChanged();
        }
    }

    QString StatusReport() const{ return statusReport;}
    void setStatusReport(const QString &StatusReport){
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
    QString statusReport;
    QString timeRequired;
    QString transferSpeed;
};

#endif // OPERATIONINDICATOR_H
