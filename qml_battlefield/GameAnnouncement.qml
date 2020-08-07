import QtQuick 2.0
import QtQuick.Controls 2.0

Popup {
    property var message
    id: popup
    width: parent.width
    height: parent.height  * 0.3
    dim: false
    visible: false
    background: GameBackground { }



     Text {
        id: textbox
        color: "#ffffff"
        text: message
        font.bold: true
        font.pointSize: 48
        horizontalAlignment: Text.AlignHCenter
        style: Text.Raised
        width: parent.width
    }
     onOpened: {
         popup.opacity = 1.0
         closeTimer.running = true
     }
     onClosed: {
            popup.opacity = 0
     }
     Behavior on opacity {
         NumberAnimation {
          duration: 2500
         }
     }
     Timer {
      id: closeTimer
      running: false
      repeat: false
      interval: 3000
      onTriggered: {
          popup.opacity = 0;
          endTimer.running = true;
      }
     }
     Timer {
      id: endTimer
      running: false
      repeat: false
      interval: 1000
      onTriggered: {
          popup.close();
      }
     }



}

