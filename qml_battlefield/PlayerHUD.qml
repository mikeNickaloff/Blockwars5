import QtQuick 2.0
import QtQuick.Controls 2.0
Item {
    id: hudRoot
    property int playerNumber
    property int playerHealth: 1000
    property int playerStartHealth: 1000
    property int movesRemaining

      function setHealth(newHealth) {
          playerHealth = newHealth
      }
      function takeHealth(newHealth) {
          playerHealth -= newHealth
      }
      function giveHealth(newHealth) {
          playerHealth += newHealth
      }
      function setMoves(newMoves) {

          movesRemaining = newMoves;
          movesTextBox.text = "  " + String(movesRemaining);

      }
      signal playerDead(var playerNumber)
      onPlayerHealthChanged: {
          control.value = (playerHealth / playerStartHealth)
      }
      Image {
       source: "qrc:///images/healthcontainer.png"
       width: hudRoot.width * 1.25
       height: hudRoot.height * 0.75
       sourceSize.width: hudRoot.width * 1.25
       sourceSize.height:  hudRoot.height * 0.75
       y: 0 - height *  0.5
      }
Row  {
    anchors.fill: hudRoot

    ProgressBar {
        width: hudRoot.width * 0.95
        height: hudRoot.height * 0.1
        id: control
           value: 1.0
           padding: 2

           background: Rectangle {
               implicitWidth: hudRoot.width * 0.95
               implicitHeight: hudRoot.height * 0.1
               color: "#e6e6e6"
               radius: 3

           }

           contentItem: Item {
               implicitWidth: hudRoot.width * 0.95
               implicitHeight: hudRoot.height * 0.1



               Rectangle {
                   width: control.visualPosition * hudRoot.width * 0.95
                   height: hudRoot.height * 0.1
                   radius: 2
                   color: "#17a81a"
               }
           }
    }

    Rectangle {
        width: hudRoot.width * 0.15
        height: hudRoot.height * 0.5
        y: 0 - hudRoot.height * 0.15
        color: "black"
        radius: 10
        z: 2000
        Text {
            id: movesTextBox
            text: movesRemaining
            font.bold: true
            font.italic: true
            horizontalAlignment: Text.AlignHLeft
            style: Text.Raised
            font.pointSize: 27
            color: "green"
        }
    }
}
}
