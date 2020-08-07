import QtQuick 2.0
import QtQuick.Controls 2.0


ApplicationWindow {
    id: window
    visible: true
    width: 740
    height: 730
    title: qsTr("Stack")

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.push("MainMenu.qml");
              }
            }
        }

        Label {
            text: stackView.currentItem.title
            anchors.centerIn: parent
        }
    }



    StackView {
        transform: [
            Rotation {
                id: sceneRotation
                axis.x: 1
                axis.y: 0
                axis.z: 0
                origin.x: width / 2
                origin.y: height / 2
                angle: 15
            },
            Translate {
                id: sceneTranslation
                x: 0
                y: 0
            }
        ]
        id: stackView
        initialItem: "MainMenu.qml"
        anchors.fill: parent
        onCurrentItemChanged: {
            stackView.currentItem.requestStackChange.connect(stackView.push);
        }

    }
}
