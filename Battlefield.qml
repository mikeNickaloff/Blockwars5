import QtQuick 2.0
import QtWebChannel 1.0
import "./qml_battlefield"
import org.nodelogic.blockwars 4.0

Item {
    property var title: "Battlefield"
    property var gridHeightMultiplier: 0.40
    property var gridWidthMultiplier: 0.90
    property var frameMultiplierOffset: 0.025
    property var gameType
    id: battlefield
    signal requestStackChange(var stack, var properties)
    width: {
        return parent.width
    }
    height: {
        return parent.height
    }

    GameEngine {
        id: engine
        gameType: battlefield.gameType
        game_started: true
        unlocked_drop_p1: false
        unlocked_drop_p2: false
        unlocked_move_p1: false
        unlocked_move_p2: false
        Component.onCompleted: {

        }
    }

    Component.onCompleted: {

        //          gridObj1.powerupAssigned.connect(sidebar1.assignPowerup)
        //          gridObj2.powerupAssigned.connect(sidebar2.assignPowerup)
        //        sidebar1.selfPowerupMatchAndExecute.connect(gridObj1.powerupMatchAndExecute)
        //        sidebar1.enemyPowerupMatchAndExecute.connect(gridObj2.powerupMatchAndExecute)
        //        sidebar2.selfPowerupMatchAndExecute.connect(gridObj2.powerupMatchAndExecute)
        //        sidebar2.enemyPowerupMatchAndExecute.connect(gridObj1.powerupMatchAndExecute)
        //gridObj1.setEngine(engine)
        //gridObj2.setEngine(engine)
        engine.notifyPlayerField.connect(gridObj1field.notifyPlayerField)
        engine.notifyPlayerField.connect(gridObj2field.notifyPlayerField)
        gridObj1.nickname = Qt.binding(function () {
            return engine.nickname_user
        })
        gridObj2.nickname = Qt.binding(function () {
            return engine.nickname_opponent
        })

        engine.init()
    }
    property alias gridObj1field: gridObj1.field
    property alias gridObj2field: gridObj2.field
    GameBackground {
        id: backgroundP1
        height: {
            return parent.height * (gridHeightMultiplier + frameMultiplierOffset)
        }
        width: {
            return parent.width * (gridWidthMultiplier + frameMultiplierOffset)
        }
        x: {
            return 0 - parent.width * frameMultiplierOffset
        }
        y: {
            return parent.height * (0.5 + frameMultiplierOffset)
        }
    }
    GameBackground {
        id: backgroundP2
        height: {
            return parent.height * (gridHeightMultiplier + frameMultiplierOffset)
        }
        width: {
            return parent.width * (gridWidthMultiplier + frameMultiplierOffset)
        }

        x: {
            return 0 - parent.width * frameMultiplierOffset
        }
        y: {
            return parent.height * frameMultiplierOffset
        }
    }
    PowerupSidebar {
        id: sidebar1
        width: {
            return parent.width * 0.14
        }
        height: containerp1.height
        anchors.left: containerp1.right
        anchors.top: containerp1.top
        z: 50
    }

    Item {
        id: containerp1
        height: {
            return parent.height * 0.42
        }
        width: {
            return parent.width * 0.825
        }
        x: {
            return parent.width * 0.025
        }
        y: {
            return parent.height * 0.52
        }
        Component.onCompleted: {
            gridField1.notifiedGameEngine.connect(
                        engine.parseLocalPlayerCommand)
        }
        PlayerContainer {
            id: gridObj1
            anchors.fill: parent
            state: "ready"
            z: 6
            WebChannel.id: "gridObj1"
            property alias field: gridField1
            property alias nickname: gridField1.nickname
            PlayerField {
                id: gridField1
                width: parent.width
                height: parent.height
            }
        }
        PlayerHUD {
            id: playerHUD1
            height: {
                return parent.height * 0.26
            }
            width: {
                return parent.width * 0.95
            }
            x: {
                return parent.width * 0
            }
            y: {
                return parent.height * 1.05
            }
            playerNumber: 1
            z: 10
        }
    }
    PowerupSidebar {
        id: sidebar2
        width: {
            return parent.width * 0.14
        }
        height: containerp2.height
        anchors.left: containerp2.right
        anchors.top: containerp2.top
        z: 50
    }
    Item {
        id: containerp2
        height: {
            return parent.height * 0.42
        }
        width: {
            return parent.width * 0.825
        }
        x: {
            return parent.width * 0.025
        }
        y: {
            return parent.height * 0.05
        }

        PlayerContainer {
            property alias announcement: g_announcement
            anchors.fill: parent
            rotation: 180
            id: gridObj2
            state: "wait"
            width: parent.width
            height: parent.height
            z: 5
            WebChannel.id: "gridObj2"
            property alias field: gridField2
            property alias nickname: gridField2.nickname

            PlayerField {

                id: gridField2
                width: parent.width
                height: parent.height
            }
        }
        PlayerHUD {
            id: playerHUD2
            height: {
                return parent.height * 0.26
            }
            width: {
                return parent.width * 0.95
            }
            x: {
                return parent.width * 0
            }
            y: {
                return 0 - parent.height * 0.05
            }
            z: 10
            playerNumber: 2
        }
        GameAnnouncement {
            id: g_announcement
            anchors.centerIn: parent
            message: "Test"
        }
        Component.onCompleted: {

        }
    }
}
