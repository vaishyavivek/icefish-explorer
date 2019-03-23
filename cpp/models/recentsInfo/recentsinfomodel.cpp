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
#include "recentsinfomodel.h"
#include <QDir>
#include <QDateTime>
#include <QTextStream>
#include <QCoreApplication>

RecentsInfoModel::RecentsInfoModel(QObject *parent) : QObject(parent)
{

}

HistoryKeeper::HistoryKeeper(QObject *parent)
    :QObject(parent){
    historyFilePath = QDir::homePath() + "/.config/" + QCoreApplication::organizationName();
    QDir dir;
    dir.mkpath(historyFilePath);

    historyFilePath += "/FileHistory.conf";
    QFile historyFile(historyFilePath);

    if(!historyFile.exists()){
        historyFile.open(QIODevice::WriteOnly);
        historyFile.close();
    }
}

void HistoryKeeper::WriteHistoryAsync(QString fileAccessed){

    if(fileAccessed.endsWith('/') && fileAccessed.length() > 1)
        fileAccessed = fileAccessed.left(fileAccessed.length() - 1);

    QFile historyFile(historyFilePath);

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

        line = QString::number(timesVisited+1) + "|" + QDateTime::currentDateTime().toString("dd/MM/yy|hh:mm") + "|" + fileAccessed;
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
    QFile historyFile(historyFilePath);
    QFile highHistoryFile(QDir::homePath() + "/.config/" + QCoreApplication::organizationName() + "/MostVisitedPlaces.conf");

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
