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
#ifndef CUTOPERATION_H
#define CUTOPERATION_H

#include <QDebug>
#include "operation.h"

class CutOperation : public Operation
{
    Q_OBJECT
    void run() override{

        emit setProgress(-1);

        foreach(QUrl nextFile, fileList)
            totalFileSize = getTheOverallFileSize(QFileInfo(nextFile.path()));

        if(totalFileSize > 0){
            elaspedTime.start();

            for(int counter = 0; counter < fileList.length(); counter++){
                QFileInfo file(fileList.at(counter).path());
                emit setHeader("Moving " + QString::number(counter + 1) + " Items of " + QString::number(fileList.length()));
                cut(file, destinitionPath);
            }

            emit setStatusReport(RFileOperator::Finished);
            saveTransferStates("Moved");

            if(!errored)
                emit setProgress(100);
        }
    }

public:
    CutOperation(QList<QUrl> FileList, QString DestinitionPath){
        fileList = FileList;
        destinitionPath = DestinitionPath;
    }

private:
    void cut(QFileInfo currentFileInfo, QString destinitionFilePath){
        if(currentFileInfo.isFile()){
            uint dataLength = 4096;
            char *data = new char[dataLength];
            long completed = 0;
            qint64 timeFraction = 0;

            QFile currentFile(currentFileInfo.filePath());
            if(!currentFile.open(QIODevice::ReadOnly)){
                qDebug() << "Permission Denied";
                emit setStatusReport(RFileOperator::Denied);
                quit();
                wait();
            }

            QFile destinationFile(destinitionFilePath + "/" + currentFileInfo.fileName());
            if(!destinationFile.open(QIODevice::ReadWrite)){
                qDebug() << "Permission Denied";
                emit setStatusReport(RFileOperator::Denied);
                quit();
                wait();
            }

            while (!currentFile.atEnd()) {
                completed += currentFile.read(data, dataLength);
                destinationFile.write(data, dataLength);

                if((elaspedTime.nsecsElapsed() - timeFraction) >= 1000000000){
                    timeFraction = elaspedTime.nsecsElapsed();
                    transferSpeed = (transferSpeed + completed)/2;
                    emit setTransferSpeed(getFormattedFileSize(completed) + "/Sec");
                    overAllCompleted += completed;
                    completed = 0;
                    emit setProgress(static_cast<int>(overAllCompleted*100/totalFileSize));
                    emit setTimeRequired(getTimeRequired(static_cast<qint64>((totalFileSize - overAllCompleted)*transferSpeed/(1024*1024))));
                }
            }

            currentFile.close();
            currentFile.remove();
            destinationFile.close();
        }
        else if(currentFileInfo.isDir()){
            QDir dir(currentFileInfo.filePath());
            dir.mkpath(destinitionFilePath + "/" + currentFileInfo.fileName());
            foreach(QFileInfo file, dir.entryInfoList(QDir::NoDotAndDotDot | QDir::NoSymLinks | QDir::Dirs | QDir::Files)){
                cut(file, destinitionFilePath + "/" + currentFileInfo.fileName());
            }
            dir.rmdir(currentFileInfo.filePath());
        }
    }
};

#endif // CUTOPERATION_H
