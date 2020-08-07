import QtQuick 2.0
import "qml_ui"
Item {
    property var title: "Single Player Menu"
    signal requestStackChange(var stack, var properties)

    id: singlePlayerMenuContainer
    ListView {
        id: singlePlayerMenuListView
      anchors.centerIn: parent
      width: { return parent.width * 0.8 }
      height: { return parent.height * 0.3 }
      model: singlePlayerMenuModel
      delegate: MainMenuButton {
          text: model.text
          width: { return singlePlayerMenuListView.width  }
          height: { return singlePlayerMenuListView.height / singlePlayerMenuModel.count }
          onMenuButtonClicked: {
              singlePlayerMenuContainer.requestStackChange(model.stack, {});
          }
      }
    }
    ListModel {
        id: singlePlayerMenuModel
        ListElement {
            text: "Random Game"
            stack: "qml_multiplayer/RandomGame.qml"

        }
        ListElement {
            text: "Normal Game"
            stack: "qml_singleplayer/NormalGame.qml"

        }

        ListElement {
            text: "Challenge a friend"
            stack: "qml_multiplayer/ChallengeGame.qml"

        }

//        ListElement {
//            text: "Practice Game"
//            stack: "qml_singleplayer/PracticeGame.qml"

//        }

//        ListElement {
//            text: "Custom Game"
//            stack:  "qml_singleplayer/CustomGame.qml"

//        }

    }
}

