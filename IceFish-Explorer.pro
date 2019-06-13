QT += quick networkauth
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
#DEFINES += QT_QML_DEBUG_NO_WARNING

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += cpp/main.cpp \
    cpp/rfilesystemmodel.cpp \
    cpp/models/bookmarkInfo/bookmarkinfomodel.cpp \
    cpp/models/diskInfo/diskinfomodel.cpp \
    cpp/models/fileFolder/filefoldermodel.cpp \
    cpp/models/recentsInfo/recentsinfomodel.cpp \
    cpp/models/notification/notificationmodel.cpp \
    cpp/models/propertiesInfo/propertiesinfomodel.cpp \
    cpp/models/trashInfo/trashinfomodel.cpp \
    cpp/models/dialogbox/rdialogbox.cpp \
    cpp/fileOperations/rfileoperator.cpp \
    cpp/fileOperations/operation.cpp \
    cpp/fileStructures/rabstractdirectorymodel.cpp \
    cpp/fileStructures/dropbox/dropbox.cpp \
    cpp/fileStructures/local/localfiles.cpp \
    cpp/fileStructures/googledrive/googledrive.cpp \
    cpp/fileStructures/onedrive/onedrive.cpp

RESOURCES += qml.qrc \
    icons.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    cpp/rfilesystemmodel.h \
    cpp/models/addressboxmodel.h \
    cpp/models/desktopfilemodel.h \
    cpp/models/menumodel.h \
    cpp/models/navigationhistorymodel.h \
    cpp/models/notification/notificationmodel.h \
    cpp/models/trashInfo/trashinfomodel.h \
    cpp/models/bookmarkInfo/bookmarkinfomodel.h \
    cpp/models/recentsInfo/recentsinfomodel.h \
    cpp/models/propertiesInfo/propertiesinfomodel.h \
    cpp/models/diskInfo/diskinfomodel.h \
    cpp/models/fileFolder/filefoldermodel.h \
    cpp/models/dialogbox/rdialogbox.h \
    cpp/qmlImageProviders/mimeiconprovider.h \
    cpp/qmlImageProviders/pixmappreviewprovider.h \
    cpp/qmlImageProviders/xdgiconprovider.h \
    cpp/qmlImageProviders/mimeinfoprovider.h \
    cpp/fileOperations/rfileoperator.h \
    cpp/fileOperations/operationindicator.h \
    cpp/fileOperations/copyoperation.h \
    cpp/fileOperations/operation.h \
    cpp/fileOperations/cutoperation.h \
    cpp/fileStructures/rabstractdirectorymodel.h \
    cpp/fileStructures/dropbox/dropbox.h \
    cpp/fileStructures/local/localfiles.h \
    cpp/fileStructures/googledrive/googledrive.h \
    cpp/fileStructures/onedrive/onedrive.h

DISTFILES +=
