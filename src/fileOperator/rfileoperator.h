#ifndef RFILEOPERATOR_H
#define RFILEOPERATOR_H

#include <QObject>
#include <QQueue>
#include <QThread>

enum class OperationState{
    Ready,
    Running,
    Denied,
    Paused,
    Interrupted,
    Finished
};


class RFileOperator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> WaitingProcessList READ WaitingProcessList NOTIFY WaitingProcessListChanged)
    Q_PROPERTY(QList<QObject*> OngoingProcessList READ OngoingProcessList NOTIFY OngoingProcessListChanged)

public:
    explicit RFileOperator(QObject *parent = nullptr);

    QList<QObject*> WaitingProcessList() const{ return waitingProcessList;}
    QList<QObject*> OngoingProcessList() const{ return ongoingProcessList;}

signals:
    void WaitingProcessListChanged();
    void OngoingProcessListChanged();
    void queueContentChanged();

public slots:
    void copyFiles(QString destinationPath);
    void moveFiles(QString destinationPath);
    void deleteFiles(QList<QObject*> fileList);
    void recoverFiles(QList<QObject*> fileList);

private:
    int runningThreadsCount;
    QQueue<QThread*> operationQueue;
    void scheduleThread();

    QList<QObject*> waitingProcessList;
    QList<QObject*> ongoingProcessList;
};


#endif // RFILEOPERATOR_H
