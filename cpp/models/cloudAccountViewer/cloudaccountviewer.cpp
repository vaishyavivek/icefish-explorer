#include "cloudaccountviewer.h"
#include <QDebug>

CloudAccountViewer::CloudAccountViewer(QObject *parent)
    : QObject(parent){
    usedSpace = 0;
    allocatedSpace = 1;
}

void CloudAccountViewer::setSpaceUsage(){
    double spaceUsed = usedSpace, spaceAllowed = allocatedSpace;
    QString usedStr = "  Bytes", allowedStr = "  Bytes";
    char byteRanges[] = {'K', 'M', 'G', 'T'};


    for(int i = 0; spaceUsed > 1023; i++){
        spaceUsed = spaceUsed/1023;
        usedStr[1] = byteRanges[i];
    }

    for(int i = 0; spaceAllowed > 1023; i++){
        spaceAllowed = spaceAllowed/1023;
        allowedStr[1] = byteRanges[i];
    }

    spaceUsage = "<b>" + QString::number(spaceUsed,'f', 2) + usedStr + "</b> Used of <b>" + QString::number(spaceAllowed,'f', 2) + allowedStr + "</b>";
    emit SpaceUsageChanged();
}
