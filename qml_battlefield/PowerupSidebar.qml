import QtQuick 2.0

Item {
    id: sidebarRoot
    signal selfPowerupMatchAndExecute(var matchProperties, var assignProperties)
    signal enemyPowerupMatchAndExecute(var matchProperties, var assignProperties)
    function chargePowerup(color, amt) {
        var slots =  [ button1, button2, button3, button4 ] ;
        for (var i=0; i<slots.length; i++) {
         slots[i].chargePowerup(color, amt);
        }
    }
    Column {
        anchors.fill: parent
        PowerupSidebarButton {

        id: button1
        height: { return parent.height * 0.22 }
        width: parent.width
        onSelfPowerupMatchAndExecute:  sidebarRoot.selfPowerupMatchAndExecute(matchProperties, assignProperties)
        onEnemyPowerupMatchAndExecute:  sidebarRoot.enemyPowerupMatchAndExecute(matchProperties, assignProperties)
    }
    PowerupSidebarButton {
        id: button2
        width: parent.width
        height: { return parent.height * 0.22 }
        onSelfPowerupMatchAndExecute:  sidebarRoot.selfPowerupMatchAndExecute(matchProperties, assignProperties)
        onEnemyPowerupMatchAndExecute:  sidebarRoot.enemyPowerupMatchAndExecute(matchProperties, assignProperties)
    }
    PowerupSidebarButton {
        id: button3
        height: { return parent.height * 0.22 }
        width: parent.width
        onSelfPowerupMatchAndExecute:  sidebarRoot.selfPowerupMatchAndExecute(matchProperties, assignProperties)
        onEnemyPowerupMatchAndExecute:  sidebarRoot.enemyPowerupMatchAndExecute(matchProperties, assignProperties)
    }
    PowerupSidebarButton {
        id: button4
        height: { return parent.height * 0.22 }
        width: parent.width
        onSelfPowerupMatchAndExecute:  sidebarRoot.selfPowerupMatchAndExecute(matchProperties, assignProperties)
        onEnemyPowerupMatchAndExecute:  sidebarRoot.enemyPowerupMatchAndExecute(matchProperties, assignProperties)
    }
    }
    function assignPowerup(slot, name) {
        var slots =  [ button1, button2, button3, button4 ] ;
        slots[slot].powerupComponentSource = "qrc:///qml_powerups/" + name + ".qml";
//        slots[slot].selfPowerupMatchAndExecute.connect()
//        slots[slot].enemyPowerupMatchAndExecute.connect(sidebarRoot.enemyPowerupMatchAndExecute)
    }
}
