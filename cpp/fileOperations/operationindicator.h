/*This file is part of IceFish Explorer.

    IceFish Explorer is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    IceFish Explorer is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with IceFish Explorer. If not, see <http://www.gnu.org/licenses/>.
*/
#ifndef OPERATIONINDICATOR_H
#define OPERATIONINDICATOR_H

#include <QObject>
#include "rfileoperator.h"

class OperationIndicator: public QObject{
    Q_OBJECT

    Q_PROPERTY(QString Header READ Header NOTIFY HeaderChanged)
    Q_PROPERTY(int Progress READ Progress NOTIFY ProgressChanged)
    Q_PROPERTY(QString SubHeader READ SubHeader NOTIFY SubHeaderChanged)
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

    QString SubHeader() const{ return subHeader;}
    void setSubHeader(const QString &SubHeader){
        if(subHeader != SubHeader){
            subHeader = SubHeader;
            emit SubHeaderChanged();
        }
    }

    RFileOperator::OperationState StatusReport() const{ return statusReport;}
    void setStatusReport(const RFileOperator::OperationState StatusReport){
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
    void SubHeaderChanged();
    void StatusReportChanged();
    void TimeRequiredChanged();
    void TransferSpeedChanged();

private:
    QString header;
    int progress;
    QString subHeader;
    RFileOperator::OperationState statusReport;
    QString timeRequired;
    QString transferSpeed;
};

#endif // OPERATIONINDICATOR_H
