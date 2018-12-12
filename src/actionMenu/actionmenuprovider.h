#ifndef ACTIONMENUPROVIDER_H
#define ACTIONMENUPROVIDER_H

#include <QObject>

class ActionMenuProvider : public QObject
{
    Q_OBJECT
public:
    explicit ActionMenuProvider(QObject *parent = nullptr);

signals:

public slots:
};

#endif // ACTIONMENUPROVIDER_H