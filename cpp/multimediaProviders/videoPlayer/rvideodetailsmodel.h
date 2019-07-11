/* $Id: rvideodetailsmodel.h
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

#ifndef RVIDEODETAILSMODEL_H
#define RVIDEODETAILSMODEL_H

#include <QObject>
//#include <QMediaPlayer>
//#include <QMediaMetaData>
//#include <id3/tag.h>
#include <QDebug>

class RVideoDetailsModel: public QObject{
    Q_OBJECT
    Q_PROPERTY(QString Title READ Title NOTIFY TitleChanged)

public:
    explicit RVideoDetailsModel(QString filePath, QObject *parent = nullptr)
        :QObject(parent){
        //player = new ID3_Tag(filePath.toLocal8Bit().data());
        //player.Link(filePath.toLocal8Bit().data());
    }

    QString Title() const{
        /*ID3_Tag::Iterator* iter = player->CreateIterator();
        ID3_Frame *frame = nullptr;
        while((frame = iter->GetNext()) != nullptr){
            qDebug() << frame;
        }

        qDebug() << player->GetFileName() << player->Size();
        qDebug() << player->Find(ID3FID_TITLE);*/
        return "null";//player.metaData(QMediaMetaData::Title).toString();
    }

signals:
    void TitleChanged();


private:
    //ID3_Tag *player;
};


#endif // RVIDEODETAILSMODEL_H


class PathSetter: public QObject{
    Q_OBJECT

public:
    explicit PathSetter(QObject *parent = nullptr)
        :QObject(parent){}

public slots:
    QObject* getVideoDetails(QString filePath){
        auto rvdm = new RVideoDetailsModel(filePath);
        return rvdm;
    }
};

