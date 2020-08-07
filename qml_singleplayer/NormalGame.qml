import QtQuick 2.0
import "../qml_shared"
import "../qml_ui"

Item {

    property var title: "Normal Game"
    signal requestStackChange(var stack, var properties)
    width: parent.width
    height: parent.height
    id: normalGameRoot
    property alias powerups: powerupChooser.powerups
    Column {
        anchors.centerIn: parent
        anchors.fill: parent
        spacing: {
            return parent.height * 0.05
        }
        ChoosePowerups {
            id: powerupChooser
            height: {
                return parent.height * 0.70
            }
            width: parent.width
            gameRoot: normalGameRoot
        }
        MainMenuButton {
            text: "Ready"
            width: {
                return parent.width * 0.65
            }
            height: {
                return parent.height * 0.15
            }
            onMenuButtonClicked: {
                requestStackChange("../Battlefield.qml", {
                                       "gameType": "single_normal",
                                       "players": [{
                                               "playerNumber": 1,
                                               "controller": "Human",
                                               "powerups": powerups
                                           }, {
                                               "playerNumber": 2,
                                               "controller": "AI",
                                               "powerups": []
                                           }]
                                   })
            }
        }
    }
}
