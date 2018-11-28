#include "HeaderFiles/notificationmodel.h"

NotificationModel::NotificationModel(QObject *parent)
    : QObject(parent){
}

void NotificationModel::Notify(Error code){
    if(code == Error::FileAlreadyExist){
        header = "That name is already occupied";
        comment = "Please chose the suggested name or something else.";
    }
    else if(code == Error::NoPermission){
        header = "Permission Insufficient";
        comment = "You don't have required permissions to modify this thing.";
    }
    else if(code == Error::PathDoesntExist){
        header = "Unknown Path";
        comment = "File path specified was not located.";
    }

    emit HeaderChanged();
    emit CommentChanged();
    emit showNotification();
}
