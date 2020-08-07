import QtQuick 2.0
import "qml_ui"
Item {
    id: mainMenuContainer
    signal requestStackChange(var stack, var properties)
       property var title: "Block Wars"





    ListView {
        id: mainMenuListView
      anchors.centerIn: parent
      width: { return parent.width * 0.8 }
      height: { return parent.height * 0.8 }
      model: mainMenuModel
      delegate: MainMenuButton {
          text: model.text
          width: { return mainMenuListView.width  }
          height: { return mainMenuListView.height / mainMenuModel.count }
          onMenuButtonClicked: {
              mainMenuContainer.requestStackChange(model.stack, {});
          }
      }
    }
    ListModel {
        id: mainMenuModel
        ListElement {
            text: "Single Player"
            stack: "SinglePlayer.qml"

        }
        ListElement {
            text: "Multiplayer"
            stack: "Multiplayer.qml"

        }
        ListElement {
            text: "Customize"

        }
        ListElement {
            text: "Settings"
        }
        ListElement {
            text: "Exit"
        }
    }
}


