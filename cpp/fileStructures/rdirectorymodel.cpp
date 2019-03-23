#include "rdirectorymodel.h"
#include "../models/fileFolder/filefoldermodel.h"


#include <QDebug>
#include <QDateTime>
#include <QtWidgets/QApplication>
#include <QMimeData>
#include <QUrl>
#include <QByteArray>
#include <QDataStream>
#include <QProcess>
#include <QDrag>
#include <QClipboard>

RDirectoryModel::RDirectoryModel(QObject *parent) :
    QObject (parent){
}


void RDirectoryModel::updateCurrentDirectory(QString newDirectoryToSwitchTo){

}

