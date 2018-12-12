#include "recentsinfomodel.h"
#include <QDir>
#include <QDateTime>
#include <QTextStream>

RecentsInfoModel::RecentsInfoModel(QObject *parent) : QObject(parent)
{

}

HistoryKeeper::HistoryKeeper(QObject *parent)
    :QObject(parent){
    historyFilePath = QDir::homePath() + "/.RevProgIFace/FileHistory.rde";

    QFile historyFile(historyFilePath);
    if(!historyFile.exists()){
        historyFile.open(QIODevice::WriteOnly);
        historyFile.close();
    }
}

void HistoryKeeper::WriteHistoryAsync(QString fileAccessed){

    if(fileAccessed.endsWith('/') && fileAccessed.length() > 1)
        fileAccessed = fileAccessed.left(fileAccessed.length() - 1);

    QFile historyFile(QDir::homePath() + "/.RevProgIFace/FileHistory.rde");

    if(!historyFile.exists()){
        historyFile.open(QIODevice::WriteOnly);
        historyFile.close();
    }

    if(historyFile.open(QIODevice::ReadOnly)){
        QString wholeFile = historyFile.readAll();
        historyFile.close();
        QStringList historyList = wholeFile.split('\n', QString::SkipEmptyParts);
        QString line;
        int timesVisited = 0;
        for(int i = 0; i < historyList.length(); i++){
            line = historyList.at(i);
            if(line.endsWith(fileAccessed)){
                line = line.left(line.indexOf('|'));
                timesVisited = line.toInt();
                historyList.removeAt(i);
                break;
            }
        }

        line = QString::number(timesVisited+1) + "|" + QDateTime::currentDateTime().toString("ddd MMMM d yyyy|hh:mm") + "|" + fileAccessed;
        historyList.append(line);

        if(historyFile.open(QIODevice::WriteOnly)){
            QTextStream stream(&historyFile);
            foreach (line, historyList) {
                stream << line << '\n';
            }
            historyFile.close();
            refineMostlyVisitedSites();
        }
    }
}

void HistoryKeeper::refineMostlyVisitedSites(){
    QFile historyFile(QDir::homePath() + "/.RevProgIFace/FileHistory.rde");
    QFile highHistoryFile(QDir::homePath() + "/.RevProgIFace/MostVisitedPlaces.rde");

    if(historyFile.open(QIODevice::ReadOnly)){
        QString wholeFile = historyFile.readAll();
        historyFile.close();
        QStringList historyList = wholeFile.split('\n', QString::SkipEmptyParts);
        QString line;
        int currentCount;
        const int totalCountOfMostVisitedPlaces = 6;
        int mostVisitedIndices[totalCountOfMostVisitedPlaces] = {0};
        int countForMostVisitedIndice[totalCountOfMostVisitedPlaces] = {0};

        int i, j, k;
        for(i = 0; i < historyList.length(); i++){
            line = historyList.at(i);
            currentCount = line.left(line.indexOf('|')).toInt();
            for(j = 0; j < totalCountOfMostVisitedPlaces; j++){
                if(countForMostVisitedIndice[j] <= currentCount){
                    for(k = 5; k > j; k--){
                        countForMostVisitedIndice[k] = countForMostVisitedIndice[k - 1];
                        mostVisitedIndices[k] = mostVisitedIndices[k - 1];
                    }
                    countForMostVisitedIndice[j] = currentCount;
                    mostVisitedIndices[j] = i;
                    break;
                }
            }
        }

        if(highHistoryFile.open(QIODevice::WriteOnly)){
            QTextStream stream(&highHistoryFile);
            for(int i = 0; i < historyList.length() && i < totalCountOfMostVisitedPlaces; i++){
                stream << historyList.at(mostVisitedIndices[i]) << '\n';
            }
            highHistoryFile.close();
        }
    }
}
