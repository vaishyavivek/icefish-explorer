#ifndef RDIALOGBOX_H
#define RDIALOGBOX_H

#include <QObject>

class RDialogBox : public QObject
{
    Q_OBJECT
    //Q_PROPERTY(QString Header READ Header WRITE setHeader NOTIFY HeaderChanged)
public:
    explicit RDialogBox(QObject *parent = nullptr);

signals:

public slots:
};

#endif // RDIALOGBOX_H
