/*This file is part of reverse-file-manager.

    reverse-file-manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    reverse-file-manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with reverse-file-manager. If not, see <http://www.gnu.org/licenses/>.
*/

#include "HeaderFiles/bookmarkinfomodel.h"

BookmarkKeeper::BookmarkKeeper(QObject *parent)
    :QObject(parent){
    bookmarkFilePath = QDir::homePath() + "/.cache/reverse-files";

    QDir dir;
    dir.mkpath(bookmarkFilePath);

    bookmarkFilePath += "/bookmarks.rde";
    QFile bookmarkFile(bookmarkFilePath);

    if(!bookmarkFile.exists()){
        bookmarkFile.open(QIODevice::WriteOnly);
        bookmarkFile.close();
    }
}


void BookmarkKeeper::add(QString filePath){
    QFile bookmarkFile(bookmarkFilePath);

    if(bookmarkFile.open(QIODevice::ReadOnly)){
        QString wholeFile = bookmarkFile.readAll();
        bookmarkFile.close();

        if(bookmarkFile.open(QIODevice::WriteOnly)){
            QTextStream stream(&bookmarkFile);
            stream << filePath << "\n" << wholeFile;
            bookmarkFile.close();
        }
    }
}


void BookmarkKeeper::remove(QString filePath){
    QFile bookmarkFile(bookmarkFilePath);

    if(bookmarkFile.open(QIODevice::ReadOnly)){
        QString wholeFile = bookmarkFile.readAll();

        QStringList list = wholeFile.split('\n', QString::SkipEmptyParts);
        if(list.contains(filePath))
            list.removeOne(filePath);

        bookmarkFile.close();
        if(bookmarkFile.open(QIODevice::WriteOnly | QIODevice::Truncate)){
            QTextStream strem(&bookmarkFile);
            foreach(QString line, list)
                strem << line <<"\n";
        }
    }

    //if request received from bookmarkList, update the .rfmdirectorysetting file at local directory also
    QFile settingFile(filePath + "/.rfmDirectorySetting");
    if(settingFile.open(QIODevice::ReadOnly)){
        QByteArray wholeSetting = settingFile.readAll();

        int indexOfSettingValue = wholeSetting.indexOf("Bookmarked");
        if(wholeSetting.mid(indexOfSettingValue, 2) != "00")
            wholeSetting.replace(indexOfSettingValue + 11, 2, "00");

        settingFile.close();
        if(settingFile.open(QIODevice::WriteOnly | QIODevice::Truncate)){
            settingFile.write(wholeSetting);
            settingFile.close();
        }
    }
}
