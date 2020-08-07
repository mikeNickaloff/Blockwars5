import QtQuick 2.0
import QtGraphicalEffects 1.0
Item {
    property var glowing: false
Image {
    id: frame
anchors.fill: parent
source: "qrc:///images/frame.png"
}
Glow {
    id: glowObj
    enabled: glowing
       anchors.fill: frame
       radius: 4
       samples: 17
       spread: 1.0
       color: "#00ff00"
       source: frame
       cached: true
   }
function setGlow(newGlow) {
    glowing = newGlow
}
function enable_glow() {
   glowObj.spread = 0.75;
    glowObj.color = "cyan"
}
function disable_glow() {
   glowObj.spread = 0;
    glowObj.color = "white"
}
}
