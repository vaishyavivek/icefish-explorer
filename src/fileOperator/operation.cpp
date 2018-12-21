#include "operation.h"

Operation::Operation(){}

QString Operation::getTimeRequired(qint64 timeInNanoSec){

    int timeInSeconds = static_cast<int>(timeInNanoSec/1000000000);
    if(timeInSeconds < 60)
        return QString::number(timeInSeconds) + " Seconds";
    else if(timeInSeconds < 60*60){
        int minute = timeInSeconds/60;
        int second = timeInSeconds%60;
        return QString::number(minute) + " Minutes and " + QString::number(second) + " Seconds";
    }
    else if(timeInSeconds < 60*60*24){
        int hour = timeInSeconds/3600;
        timeInSeconds = timeInSeconds%3600;
        int minute = timeInSeconds/60;
        int second = timeInSeconds%60;
        return QString::number(hour) + " Hours, " + QString::number(minute) + " Minutes and " + QString::number(second) + " Seconds";
    }
    else if(timeInSeconds < 60*60*24*7){
        int day = timeInSeconds/(3600*24);
        timeInSeconds = timeInSeconds%(3600*24);
        int hour = timeInSeconds/3600;
        timeInSeconds = timeInSeconds%3600;
        int minute = timeInSeconds/60;
        int second = timeInSeconds%60;
        return QString::number(day) + " Days, " + QString::number(hour) + " Hours, " + QString::number(minute) + " Minutes and " + QString::number(second) + " Seconds";
    }
    else if(timeInSeconds < 60*60*24*30){
        int week = timeInSeconds/(3600*24*7);
        timeInSeconds = timeInSeconds%(3600*24*7);
        int day = timeInSeconds/(3600*24);
        timeInSeconds = timeInSeconds%(3600*24);
        int hour = timeInSeconds/3600;
        timeInSeconds = timeInSeconds%3600;
        int minute = timeInSeconds/60;
        int second = timeInSeconds%60;
        return QString::number(week) + " Weeks, " + QString::number(day) + " Days, " + QString::number(hour) + " Hours, " + QString::number(minute) + " Minutes and " + QString::number(second) + " Seconds";
    }
    else if(timeInSeconds < 60*60*24*30*12){
        int month = timeInSeconds/(3600*24*30);
        timeInSeconds = timeInSeconds%(3600*24*30);
        int day = timeInSeconds/(3600*24);
        timeInSeconds = timeInSeconds%(3600*24);
        int hour = timeInSeconds/3600;
        timeInSeconds = timeInSeconds%3600;
        int minute = timeInSeconds/60;
        int second = timeInSeconds%60;
        return QString::number(month) + " Months, " + QString::number(day) + " Days, " + QString::number(hour) + " Hours, " + QString::number(minute) + " Minutes and " + QString::number(second) + " Seconds";
    }
    else if(timeInSeconds > 60*60*24*30*12){
        int year = timeInSeconds/(3600*24*30*12);
        timeInSeconds = timeInSeconds%(3600*24*30);
        int month = timeInSeconds/(3600*24*30);
        timeInSeconds = timeInSeconds%(3600*24*30);
        int day = timeInSeconds/(3600*24);
        timeInSeconds = timeInSeconds%(3600*24);
        int hour = timeInSeconds/3600;
        timeInSeconds = timeInSeconds%3600;
        int minute = timeInSeconds/60;
        int second = timeInSeconds%60;
        return QString::number(year) + " Years, " + QString::number(month) + " Months, " + QString::number(day) + " Days, " + QString::number(hour) + " Hours, " + QString::number(minute) + " Minutes and " + QString::number(second) + " Seconds";
    }
    else
        return "Unkown time";
}


qint64 Operation::getTheOverallFileSize(QFileInfo file){
    if(file.exists()){
        qint64 finalSize = 0;
        if(file.isFile())
            finalSize += file.size();
        else if(file.isDir()){
            QDir dir(file.absoluteFilePath());
            QFileInfoList fileList = dir.entryInfoList(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot | QDir::NoSymLinks);
            foreach (QFileInfo anotherFile, fileList) {
                qint64 whetherDirNotExist = getTheOverallFileSize(anotherFile);
                if(whetherDirNotExist >= 0)
                    finalSize += whetherDirNotExist;
            }
            finalSize += 4096;
        }
        else
            finalSize = 0;
        return finalSize;
    }
    else
        return -1;
}

QString Operation::getFormattedFileSize(qint64 fileSize){
    if(fileSize < 1024)
        return QString::number(fileSize, 'f', 2) + " Bytes";
    else if(fileSize < 1024*1024)
        return QString::number(fileSize/1024, 'f', 2) + " KBytes";
    else if(fileSize < 1024*1024*1024)
        return QString::number(fileSize/(1024*1024), 'f', 2) + " MBytes";
    else if(fileSize > 1024*1024*1024)
        return QString::number(fileSize/(1024*1024*1024), 'f', 2) + " GBytes";
    else
        return " Unknown";
}
