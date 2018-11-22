#ifndef NOTIFICATIONMODEL_H
#define NOTIFICATIONMODEL_H

#include <QObject>


enum class Error{
    StackLeak,
    FileAlreadyExist,
    PathDoesntExist,
    NoPermission,
    Unknown
};

class NotificationModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString Comment READ Comment NOTIFY CommentChanged)
    Q_PROPERTY(QString Header READ Header NOTIFY HeaderChanged)

public:
    explicit NotificationModel(QObject *parent = nullptr);

    QString Comment() const{ return comment;}
    QString Header() const{ return header;}

signals:
    void CommentChanged();
    void HeaderChanged();

    void showNotification();

public slots:
    void Notify(Error);

private:
    QString comment, header;
};

#endif // NOTIFICATIONMODEL_H
