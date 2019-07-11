/* $Id: rfileoperator.cpp
 * IceFish Explorer is a free File Manager for Linux Desktops for managing
 * local files as well as files on cloud, Dropbox, Onedrive, Googledrive.
 * Additionally, it also serves as a multimedia explorer for your photos,
 * music, videos, documents and other files by providing built-in plugins
 * to open them.
 * © IceFish Community, 2019
 *
 * This file is part of IceFish Explorer.
 *
 * IceFish Explorer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * IceFish Explorer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with IceFish Explorer.
 * If not, see <http://www.gnu.org/licenses/>.
 *
 * The project is hosted here,
 * http://www.icefish.tech/index/explorer/0-5
*/

#include "rfileoperator.h"
#include "operationindicator.h"
#include "copyoperation.h"
#include "cutoperation.h"

#include <QtWidgets/QApplication>
#include <QClipboard>
#include <QMimeData>

RFileOperator::RFileOperator(QObject *parent) : QObject(parent){
    runningThreadsCount = 0;
    qRegisterMetaType<RFileOperator::OperationState>("RFileOperator::OperationState");
    connect(this, &RFileOperator::queueContentChanged, this, &RFileOperator::scheduleThread);

    completedOperationsFilePath = QDir::homePath() + "/.config/" + QCoreApplication::organizationName() + "/" +
            QCoreApplication::applicationName() + "-operations.conf";
    watcher.addPath(completedOperationsFilePath);
    connect(&watcher, &QFileSystemWatcher::fileChanged, this, &RFileOperator::updateCompletedList);
    updateCompletedList();
}

void RFileOperator::scheduleThread(){
    if(ongoingProcessList.length() <= 2 && waitingProcessList.length() > 0){
        OperationIndicator *opi = qobject_cast<OperationIndicator*>(waitingProcessList.first());
        opi->setStatusReport(OperationState::Running);
        ongoingProcessList.append(opi);
        emit OngoingProcessListChanged();

        waitingProcessList.removeFirst();
        emit WaitingProcessListChanged();

        operationQueue.dequeue()->start();
    }
}

void RFileOperator::resetProcessList(){
    OperationIndicator *opif = qobject_cast<OperationIndicator*>(ongoingProcessList.first());
    if(opif->StatusReport() == RFileOperator::Finished)
        ongoingProcessList.removeFirst();
    else{
        OperationIndicator *opil = qobject_cast<OperationIndicator*>(ongoingProcessList.last());
        if(opil->StatusReport() == RFileOperator::Finished)
            ongoingProcessList.removeLast();
    }
    emit OngoingProcessListChanged();
    emit queueContentChanged();
}


void RFileOperator::updateCompletedList(QString path){
    Q_UNUSED(path);
    QFile file(completedOperationsFilePath);
    if(file.exists() && file.open(QIODevice::ReadOnly)){
        QString buffer = file.readAll();
        file.close();
        completedProcessList.clear();
        QStringList updateList = buffer.split('\n', QString::SkipEmptyParts);
        foreach(QString anotherOp, updateList){
            anotherOp = anotherOp.mid(1, anotherOp.length() - 1);
            QStringList dataList = anotherOp.split(';', QString::SkipEmptyParts);
            OperationIndicator *opic = new OperationIndicator();
            opic->setHeader(dataList.at(0).split(':').at(1) + " " +
                            QString::number(dataList.at(1).split(':').length()) + " Items to " +
                            dataList.at(2).split(':').at(1));
            opic->setTimeRequired(dataList.at(3).split(':').at(1));
            opic->setTransferSpeed(dataList.at(4).split(':').at(1));
            completedProcessList.append(opic);
        }
        emit CompletedProcessListChanged();
    }
}


void RFileOperator::copyFiles(QString destinationPath){
    OperationIndicator *opObj = new OperationIndicator();
    CopyOperation *thread = new CopyOperation(QApplication::clipboard()->mimeData()->urls(), destinationPath);

    connect(thread, &CopyOperation::setHeader, opObj, &OperationIndicator::setHeader);
    connect(thread, &CopyOperation::setProgress, opObj, &OperationIndicator::setProgress);
    connect(thread, &CopyOperation::setStatusReport, opObj, &OperationIndicator::setStatusReport);
    connect(thread, &CopyOperation::setTimeRequired, opObj, &OperationIndicator::setTimeRequired);
    connect(thread, &CopyOperation::setTransferSpeed, opObj, &OperationIndicator::setTransferSpeed);
    connect(thread, &CopyOperation::finished, this, &RFileOperator::resetProcessList);

    opObj->setStatusReport(OperationState::Ready);

    waitingProcessList.append(opObj);
    emit WaitingProcessListChanged();
    operationQueue.enqueue(thread);
    emit queueContentChanged();
}


void RFileOperator::moveFiles(QString destinationPath){
    OperationIndicator *opObj = new OperationIndicator();
    CutOperation *thread = new CutOperation(QApplication::clipboard()->mimeData()->urls(), destinationPath);

    connect(thread, &CutOperation::setHeader, opObj, &OperationIndicator::setHeader);
    connect(thread, &CutOperation::setProgress, opObj, &OperationIndicator::setProgress);
    connect(thread, &CutOperation::setTimeRequired, opObj, &OperationIndicator::setTimeRequired);
    connect(thread, &CutOperation::setTransferSpeed, opObj, &OperationIndicator::setTransferSpeed);
    connect(thread, &CutOperation::finished, this, &RFileOperator::scheduleThread);

    opObj->setStatusReport(OperationState::Ready);

    waitingProcessList.append(opObj);
    emit WaitingProcessListChanged();
    operationQueue.enqueue(thread);
    emit queueContentChanged();
}

void RFileOperator::deleteFiles(QList<QObject*> fileList){}

void RFileOperator::recoverFiles(QList<QObject*> fileList){}
