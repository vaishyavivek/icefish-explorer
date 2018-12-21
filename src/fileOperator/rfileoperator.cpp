#include "rfileoperator.h"
#include "operationindicator.h"
#include "copyoperation.h"
#include "cutoperation.h"

#include <QtWidgets/QApplication>
#include <QClipboard>
#include <QMimeData>

RFileOperator::RFileOperator(QObject *parent) : QObject(parent){
    runningThreadsCount = 0;
    connect(this, &RFileOperator::queueContentChanged, this, &RFileOperator::scheduleThread);
}

void RFileOperator::scheduleThread(){
    if(runningThreadsCount <= 2 && waitingProcessList.length() > 0){
        ongoingProcessList.append(waitingProcessList.first());
        emit OngoingProcessListChanged();

        waitingProcessList.removeFirst();
        emit WaitingProcessListChanged();

        operationQueue.dequeue()->start();
        runningThreadsCount++;
    }
}

void RFileOperator::copyFiles(QString destinationPath){
    OperationIndicator *opObj = new OperationIndicator();
    CopyOperation *thread = new CopyOperation(QApplication::clipboard()->mimeData()->urls(), destinationPath);

    connect(thread, &CopyOperation::setHeader, opObj, &OperationIndicator::setHeader);
    connect(thread, &CopyOperation::setProgress, opObj, &OperationIndicator::setProgress);
    connect(thread, &CopyOperation::setTimeRequired, opObj, &OperationIndicator::setTimeRequired);
    connect(thread, &CopyOperation::setTransferSpeed, opObj, &OperationIndicator::setTransferSpeed);
    connect(thread, &CopyOperation::finished, this, &RFileOperator::scheduleThread);

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
