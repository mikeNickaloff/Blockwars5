import QtQuick 2.0

Item {
    id: buttonRoot
    signal selfPowerupMatchAndExecute(var matchProperties, var assignProperties)
    signal enemyPowerupMatchAndExecute(var matchProperties, var assignProperties)
    function chargePowerup(color, amt) {
        if ((typeof powerupLoader.item !== "undefined") && (powerupLoader.item !== null)) {
            powerupLoader.item.addEnergy(color, amt);
        }
    }
    Loader {
        id: powerupLoader
        anchors.fill: parent
    }

    Connections {
            target: powerupLoader.item
            onSelfPowerupMatchAndExecute: { buttonRoot.selfPowerupMatchAndExecute(matchProperties, assignProperties) }
            onEnemyPowerupMatchAndExecute: { buttonRoot.enemyPowerupMatchAndExecute(matchProperties, assignProperties) }
        }
    property var powerupComponentSource
    onPowerupComponentSourceChanged: {
        powerupLoader.source = powerupComponentSource;
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: false
        propagateComposedEvents: true
        onClicked: {
            powerupLoader.item.activate();
        }

    }
}
