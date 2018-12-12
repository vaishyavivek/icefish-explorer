#include "rfileoperator.h"

RFileOperator::RFileOperator(QObject *parent) : QObject(parent)
{}


void RFileOperator::copyFiles(QString originalPath, QString destinationPath, QList<QObject*> fileList){}


void RFileOperator::moveFiles(QString originalPath, QString destinationPath, QList<QObject*> fileList){}

void RFileOperator::deleteFiles(QList<QObject*> fileList){}

void RFileOperator::recoverFiles(QList<QObject*> fileList){}
