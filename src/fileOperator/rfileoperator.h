#ifndef RFILEOPERATOR_H
#define RFILEOPERATOR_H

#include <QObject>
#include <QQueue>
#include <QThread>
#include <QtCore>


class RFileOperator : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QList<QObject*> WaitingProcessList READ WaitingProcessList NOTIFY WaitingProcessListChanged)
    Q_PROPERTY(QList<QObject*> OngoingProcessList READ OngoingProcessList NOTIFY OngoingProcessListChanged)
    Q_PROPERTY(QList<QObject*> CompletedProcessList READ CompletedProcessList NOTIFY CompletedProcessListChanged)

public:
    explicit RFileOperator(QObject *parent = nullptr);

    enum OperationState{
        Ready,
        Running,
        Denied,
        Paused,
        Interrupted,
        Finished
    };
    Q_ENUM(OperationState)

    QList<QObject*> WaitingProcessList() const{ return waitingProcessList;}
    QList<QObject*> OngoingProcessList() const{ return ongoingProcessList;}
    QList<QObject*> CompletedProcessList() const{ return completedProcessList;}

signals:
    void WaitingProcessListChanged();
    void OngoingProcessListChanged();
    void CompletedProcessListChanged();
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
    void resetProcessList();
    void updateCompletedList(QString path = "");

    QList<QObject*> waitingProcessList;
    QList<QObject*> ongoingProcessList;
    QList<QObject*> completedProcessList;

    QFileSystemWatcher watcher;
    QString completedOperationsFilePath;
};

Q_DECLARE_METATYPE(RFileOperator::OperationState)

#endif // RFILEOPERATOR_H
