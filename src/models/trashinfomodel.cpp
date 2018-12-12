#include "trashinfomodel.h"

void TrashInfoModel::recover(){
    QFile fileToRecover(currentPath);
    QString fileInfoName = currentPath;
    fileInfoName = fileInfoName.replace("files", "info");
    fileInfoName.append(".trashinfo");

    QFile fileInfo(fileInfoName);
    if(fileInfo.exists()){
        fileInfo.open(QIODevice::ReadOnly);
        QTextStream stream(&fileInfo);

        QString lines = stream.readLine();
        lines = stream.readLine();
        lines = lines.right(lines.length() - 5);

        QFile verify(lines);
        if(!verify.exists()){
            if(!fileToRecover.rename(lines))
                emit notify(Error::NoPermission);
            else{
                fileInfo.close();
                fileInfo.remove();
                deleteLater();
            }
        }
        else
            emit notify(Error::FileAlreadyExist);
    }
    else
        emit notify(Error::PathDoesntExist);
}


void TrashInfoModel::remove(){

    QFile file(currentPath);
    if(file.remove()){
        QFile trashInfo(currentPath + ".trashinfo");
        if(!trashInfo.remove())
            emit notify(Error::RemovalFailed);
    }
    else
        emit notify(Error::RemovalFailed);
}
