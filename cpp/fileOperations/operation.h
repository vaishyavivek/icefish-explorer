/* $Id: operation.h
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

#ifndef OPERATION_H
#define OPERATION_H

#include <QObject>
#include <QThread>
#include <QUrl>
#include <QFileInfo>
#include <QDir>
#include <QElapsedTimer>
#include "rfileoperator.h"

class Operation : public QThread
{
    Q_OBJECT
public:
    Operation();

signals:
    void setHeader(const QString &);
    void setProgress(int );
    void setSubHeader(const QString &);
    void setStatusReport(RFileOperator::OperationState);
    void setTimeRequired(const QString &);
    void setTransferSpeed(const QString &);

protected:
    qint64 getTheOverallFileSize(QFileInfo file);
    QString getFormattedFileSize(qint64 fileSize);
    QString getTimeRequired(qint64);
    void saveTransferStates(QString opType);

    QList<QUrl> fileList;
    QString destinitionPath;
    QElapsedTimer elaspedTime;

    long long overAllCompleted = 0;
    int errored = 0;
    qint64 totalFileSize = 0;
    double transferSpeed = 0;

    int dirCount = 0;
    int fileCount = 0;
};

#endif // OPERATION_H
