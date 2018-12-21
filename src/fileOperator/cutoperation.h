#ifndef CUTOPERATION_H
#define CUTOPERATION_H

#include <QDebug>
#include "operation.h"

class CutOperation : public Operation
{
    Q_OBJECT
    void run() override{
        int errored = 0;
        emit setProgress(-1);
        qint64 totalFileSize = 0;
        foreach(QUrl nextFile, fileList)
            totalFileSize = getTheOverallFileSize(QFileInfo(nextFile.path()));

        if(totalFileSize > 0){
            long long overAllCompleted = 0;
            elaspedTime.start();
            double transferSpeed = 0;

            for(int counter = 0; counter < fileList.length(); counter++){
                QFileInfo file(fileList.at(counter).path());
                uint dataLength = 4096;
                char *data = new char[dataLength];
                long completed = 0;
                qint64 timeFraction = 0;

                emit setHeader("Copying " + QString::number(counter + 1) + " Items of " + QString::number(fileList.length()));

                QFile currentFile(file.filePath());
                if(!currentFile.open(QIODevice::ReadOnly)){
                    qDebug() << "Permission Denied";
                    errored = 1;
                    break;
                }

                QFile destinationFile(destinitionPath + "/" + file.fileName());
                if(!destinationFile.open(QIODevice::ReadWrite)){
                    qDebug() << "Permission Denied";
                    errored = 1;
                    break;
                }

                while (!currentFile.atEnd()) {
                    completed += currentFile.read(data, dataLength);
                    destinationFile.write(data, dataLength);

                    if((elaspedTime.nsecsElapsed() - timeFraction) >= 1000000000){
                        transferSpeed = (transferSpeed + completed)/2;
                        emit setTransferSpeed(getFormattedFileSize(completed) + "/Sec");
                        overAllCompleted += completed;
                        completed = 0;
                        timeFraction = elaspedTime.nsecsElapsed();
                        emit setProgress(static_cast<int>(overAllCompleted*100/totalFileSize));
                        emit setTimeRequired(getTimeRequired(static_cast<qint64>((totalFileSize - overAllCompleted)*transferSpeed/(1024*1024))));
                    }
                }

                currentFile.close();
                currentFile.remove();
                destinationFile.close();
            }
            if(!errored)
                emit setProgress(100);
        }
    }

public:
    CutOperation(QList<QUrl> FileList, QString DestinitionPath){
        fileList = FileList;
        destinitionPath = DestinitionPath;
    }
};

#endif // CUTOPERATION_H
