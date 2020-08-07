QT += qml quick opengl webchannel websockets gui

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0
include(lib/qt-supermacros/QtSuperMacros.pri)
PARTICLE_EXPLOSION_COUNT = 25
DEFINES += PARTICLE_EXPLOSION_COUNT
SOURCES += \
        main.cpp \
        simplecrypt.cpp \
        src_battlefield/blockevent.cpp \
        src_battlefield/blockmanager.cpp \
        src_battlefield/gameengine.cpp \
        src_battlefield/internalgamegrid.cpp \
        src_battlefield/websocketclientwrapper.cpp \
        src_battlefield/websockettransport.cpp \
        src_input/aiplayerinputsource.cpp \
        src_input/humanplayerinputsource.cpp \
        src_input/ircconnection.cpp \
        src_input/player.cpp \
        src_input/playerinputsource.cpp \
        src_input/remoteplayerinputsource.cpp \
        src_network/zip.cpp

RESOURCES += qml.qrc

TRANSLATIONS += \
    Blockwars5_en_US.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    Battlefield.qml \
    MainMenu.qml \
    Multiplayer.qml \
    README.md \
    SinglePlayer.qml \
    js_workers/asdf.qml \
    js_workers/blockmath.js \
    js_workers/drop.js \
    main.qml \
    qml_battlefield/Block.qml \
    qml_battlefield/BlockEmitter.qml \
    qml_battlefield/BlockItemParticle.qml \
    qml_battlefield/GameAnnouncement.qml \
    qml_battlefield/GameBackground.qml \
    qml_battlefield/GameGrid.js \
    qml_battlefield/GameGrid.qml \
    qml_battlefield/GameParticles.qml \
    qml_battlefield/PlayerHUD.qml \
    qml_battlefield/PowerupSidebar.qml \
    qml_battlefield/PowerupSidebarButton.qml \
    qml_battlefield/RemoteAPI.qml \
    qml_battlefield/TurnController.qml \
    qml_battlefield/gamegrid.diff \
    qml_battlefield/oldGameGrid.qml \
    qml_multiplayer/RandomGame.qml \
    qml_powerups/BlueShield.qml \
    qml_powerups/Crossblade.qml \
    qml_powerups/Fireball.qml \
    qml_powerups/PowerupActions.qml \
    qml_powerups/PowerupBase.qml \
    qml_powerups/RedSword.qml \
    qml_shared/ChoosePowerups.qml \
    qml_shared/PowerupModel.qml \
    qml_singleplayer/NormalGame.qml \
    qml_ui/MainMenuButton.qml \
    qtquickcontrols2.conf \
    qwebchannel.js \
    sounds/1shot_close.ogg \
    sounds/1shot_error.ogg \
    sounds/1shot_open.ogg \
    sounds/bfg_explode1.wav \
    sounds/bfg_explode2.wav \
    sounds/bfg_explode3.wav \
    sounds/bfg_explode4.wav \
    sounds/bfg_fire.wav \
    sounds/bfg_firebegin.wav \
    sounds/explode1.wav \
    sounds/explode2.wav \
    sounds/explode3.wav \
    sounds/explode4.wav \
    sounds/explode5.wav \
    sounds/slam_01.ogg \
    sounds/slam_03.wav \
    sounds/slam_05.wav \
    sounds/slam_06.wav \
    sounds/slam_08_boomy.wav \
    sounds/whiz1.ogg \
    sounds/whiz2.ogg \
    sounds/whiz3.ogg \
    sounds/whiz4.ogg

HEADERS += \
    QQmlObjectListModel.h \
    simplecrypt.h \
    src_battlefield/blockevent.h \
    src_battlefield/blockmanager.h \
    src_battlefield/gameengine.h \
    src_battlefield/internalgamegrid.h \
    src_battlefield/websocketclientwrapper.h \
    src_battlefield/websockettransport.h \
    src_input/aiplayerinputsource.h \
    src_input/humanplayerinputsource.h \
    src_input/ircconnection.h \
    src_input/player.h \
    src_input/playerinputsource.h \
    src_input/remoteplayerinputsource.h \
    src_network/zip.h
