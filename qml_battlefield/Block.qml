import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {
    id: itemRoot
    objectName: "Block"
    property int row: 0
    property int col: 0
    property alias column: itemRoot.col
    property bool blockDestroyed: false
    property bool alreadyExploded: false
    property int frozenRounds: 0
    property int burningRounds: 0
    property int invulnerableRounds: 0
    property string hero
    signal animComplete(var irow, var icol)
    signal launched(var row, var col)
    signal exploded(var uuid)
    signal requestRowChange(var row, var col, var newRow)
    signal requestLaunch(var row, var col)
    signal requestTarget(var row, var col, var health)
    signal requestExplosionParticles(var row, var col)
    signal announcePosition(var xpos, var ypos, var uuid)
    signal announceState(var uuid, var newState)

    signal provideBlockGridPosition(var uuid, var row, var col)
    property int movementDuration: 300
    property var blockColor: "gold"
    onBlockColorChanged: {
        itemRoot.notifyColorChange(itemRoot.row, itemRoot.col,
                                   itemRoot.blockColor)
    }
    signal notifyColorChange(var row, var col, var color)
    property int blockHealth: 5
    property alias health: itemRoot.blockHealth
    property var blockStates: ["idle", "launch", "airbourne", "dead", "markedForDeath", "exploding", "matched", "healthGain"]

    /* for block swapping code */
    property var movementDirection
    property int dragStartX
    property int dragStartY
    property var selectedBlock
    property int airbournePositionUpdateCounter: 0
    property var isHuman: false
    property alias x_anim_interpolator: xMovementInterpolator.enabled
    property alias y_anim_interpolator: yMovementInterpolator.enabled

    signal blockSelected(var row, var col)
    signal movementChanged(var uuid, var direction, var row, var col)

    property var itemStartX
    property var itemStartY
    property var uiBlockActivateProp: true
    property var preFallState
    property bool foundTargetAlready: false

    // v2 signals
    property var uuid: ""
    signal loadFinished(var i_block)
    signal requestAPIUpdateBlockPosition(var uuid, var row, var col)
    function activateUI() {
        itemRoot.uiBlockActivateProp = true
    }
    function deactivateUI() {
        itemRoot.uiBlockActivateProp = false
    }
    signal goingToMove(var row, var col, var i_direction, int dx, int dy)
    function destroyIfNot(irow, icol, iitem) {
        if (irow === row) {
            if (icol === col) {
                if (iitem !== itemRoot) {

                    /*itemRoot.destroy(100);*/ }
            }
        }
    }
    signal blockLanded(var row, var col)
    onBlockDestroyedChanged: {
        if (blockDestroyed === true) {
            if (alreadyExploded === false) {
                itemRoot.state = "exploding"
                alreadyExploded = true
            }
        }
    }

    onRowChanged: {
        requestAPIUpdateBlockPosition(itemRoot.uuid, row, col)
    }
    onColChanged: {
        requestAPIUpdateBlockPosition(itemRoot.uuid, row, col)
    }
    onStateChanged: {

        //    announceState(itemRoot.uuid, itemRoot.state);
    }
    state: "idle"
    z: 1000

    //    Behavior on blockColor {
    //        SequentialAnimation {
    //            PropertyAnimation {
    //             target: itemRoot
    //             property: "opacity"
    //             from: 1.0
    //             to: 0
    //             duration: 300

    //            }
    //            PropertyAnimation {
    //             target: itemRoot
    //             property: "opacity"
    //             from: 0
    //             to: 1.0
    //             duration: 500

    //            }
    //        }
    //    }
    Text {
        z: 4000
        text: itemRoot.state
        anchors.centerIn: parent
        id: displayText
    }
    Behavior on y {
        SequentialAnimation {
            ScriptAction {
                script: {
                    if (itemRoot.state !== "falling") {
                        itemRoot.preFallState = itemRoot.state
                        itemRoot.state = "falling"
                    }
                }
            }
            NumberAnimation {

                duration: movementDuration
            }
            ScriptAction {
                script: {
                    itemRoot.state = itemRoot.preFallState
                }
            }
        }
    }

    states: [
        State {
            name: "idle"
            PropertyChanges {
                target: loader
                sourceComponent: blockIdleComponent
            }
            StateChangeScript {
                script: {
                    itemRoot.blockLanded(itemRoot.row, itemRoot.col)
                }
            }
            PropertyChanges {
                target: itemRoot
                z: 900
            }
        },
        State {
            name: "launch"
            PropertyChanges {
                target: loader
                sourceComponent: blockLaunchComponent
            }
            PropertyChanges {
                target: itemRoot
                z: 1000
            }
            StateChangeScript {
                script: {
                    xMovementInterpolator.enabled = true
                    yMovementInterpolator.enabled = true
                    announcePositionTimer.running = true
                    announcePositionTimer.restart()
                }
            }
        },

        State {
            name: "dead"
            PropertyChanges {
                target: loader
                sourceComponent: undefined
            }
        },

        State {
            name: "airbourne"
            StateChangeScript {
                script: {
                    requestTargetTimer.restart()
                    //      itemRoot.requestTarget(itemRoot.row, itemRoot.col, itemRoot.blockHealth);


                    /*loader.item.frameCount = 13;
                    loader.item.currentFrame = 7; */
                }
            }
        },
        State {
            name: "markedForDeath"
            PropertyChanges {
                target: loader
                sourceComponent: undefined
            }
        },
        State {
            name: "exploding"
            PropertyChanges {
                target: loader
                sourceComponent: blockExplodeComponent
            }
            StateChangeScript {
                script: {
                    xMovementInterpolator.enabled = false
                    yMovementInterpolator.enabled = false
                    requestExplosionParticles(itemRoot.row, itemRoot.col)
                }
            }
        },
        State {
            name: "matched"
        },
        State {
            name: "healthGain"
            PropertyChanges {
                target: loader
                sourceComponent: healthGainComponent
            }
            StateChangeScript {
                script: {
                    resetBlockTimer.running = true
                }
            }
        },
        State {
            name: "falling"
        }
    ]
    transitions: [
        Transition {}
    ]

    property var explodeTimerRunning: false
    Timer {
        id: announcePositionTimer
        interval: 200
        onTriggered: {
            announcePosition(itemRoot.x, itemRoot.y, itemRoot.uuid)
        }
        running: false
        repeat: true
    }
    Timer {
        id: requestTargetTimer
        interval: 5
        running: false
        repeat: false
        onTriggered: {
            if (!foundTargetAlready) {
                itemRoot.requestTarget(itemRoot.row, itemRoot.col,
                                       itemRoot.blockHealth)
                foundTargetAlready = true
            } else {

            }
        }
    }
    Timer {
        id: untilExplodeTimer
        interval: itemRoot.movementDuration
        running: explodeTimerRunning
        repeat: false
        onTriggered: {
            itemRoot.state = "exploding"
        }
    }

    Timer {
        id: resetBlockTimer
        interval: 3000
        repeat: false
        running: false
        onTriggered: {
            itemRoot.state = "idle"
        }
    }

    Component {
        id: healthGainComponent
        Item {
            property alias spread: blockGlow.spread
            anchors.centerIn: parent
            height: {
                return itemRoot.height * 0.90
            }
            width: {
                return itemRoot.width * 0.90
            }
            Image {
                source: "qrc:///images/block_" + itemRoot.blockColor + ".png"

                anchors.fill: parent
                id: blockImage
                asynchronous: true
                opacity: 1.0
                sourceSize.height: blockImage.height
                sourceSize.width: blockImage.width
                anchors.centerIn: parent
                visible: true
            }
            Component.onCompleted: {
                blockGlow.spread = 1.0
            }
            Glow {
                id: blockGlow
                anchors.fill: blockImage
                radius: 8
                samples: 17
                color: "white"
                source: blockImage
                spread: 0.0
                Behavior on spread {
                    SequentialAnimation {

                        NumberAnimation {
                            duration: 1400
                        }
                        ScriptAction {
                            script: {
                                if (blockGlow.spread > 0) {
                                    blockGlow.spread = 0
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: blockIdleComponent
        Image {
            source: "qrc:///images/block_" + itemRoot.blockColor + ".png"
            height: {
                return itemRoot.height * 0.90
            }
            width: {
                return itemRoot.width * 0.90
            }

            id: blockImage
            asynchronous: true
            opacity: 1.0
            sourceSize.height: blockImage.height
            sourceSize.width: blockImage.width
            anchors.centerIn: parent
            visible: true
        }
    }

    Component {
        id: blockLaunchComponent

        AnimatedSprite {

            id: sprite
            anchors.centerIn: parent
            height: {
                return itemRoot.height * 0.90
            }
            width: {
                return itemRoot.width * 0.90
            }
            source: "qrc:///images/block_firebrick_ss.png"
            frameCount: 5
            currentFrame: 0
            reverse: false
            frameSync: false
            frameWidth: 64
            frameHeight: 64
            loops: 1
            running: true
            frameDuration: 250
            interpolate: true

            smooth: true
            property var colorName: itemRoot.blockColor

            onColorNameChanged: {
                sprite.source = "qrc:///images/block_" + colorName + "_ss.png"
            }
            onFinished: {

                itemRoot.state = "airbourne"
                itemRoot.explodeTimerRunning = true

                //               if (currentFrame === 7) {

                //               }
            }
        }
    }
    Component {
        id: blockExplodeComponent

        AnimatedSprite {
            id: sprite
            width: itemRoot.width * 2
            height: itemRoot.height * 2

            x: 0 - (itemRoot.width * 0.5)
            y: 0 - (itemRoot.height * 0.5)

            z: 7000

            //source: "qrc:///images/explode_hi_ss.png"
            //frameCount: 25
            //frameWidth: 64
            //frameHeight: 64
            source: "qrc:///images/explode_ss.png"
            frameCount: 20
            frameWidth: 64
            frameHeight: 64

            reverse: false
            frameSync: false

            loops: 1
            running: true
            frameRate: 40
            interpolate: true

            smooth: false
            onFinished: {
                itemRoot.explode()
            }
        }
    }

    Behavior on y {
        id: yMovementInterpolator
        enabled: true
        ParallelAnimation {
            NumberAnimation {
                duration: {
                    return 250
                }
            }
        }
    }
    Behavior on x {
        id: xMovementInterpolator
        enabled: true
        NumberAnimation {
            duration: 250
        }
    }

    property alias animRoot: itemRoot
    property alias mainItem: itemRoot
    property alias gameBlock: itemRoot

    MouseArea {
        z: 2
        anchors.fill: parent
        enabled: itemRoot.uiBlockActivateProp
        hoverEnabled: false
        propagateComposedEvents: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPressed: {

            // console.log("Mouse pressed on " + row_index + " / " + cell_index);
            if (pressedButtons & Qt.RightButton) {
                displayText.text = itemRoot.state.substring(0,
                                                            1) + " " + String(
                            itemRoot.health)
                itemRoot.state = "launch"
            } else {
                mainItem.dragStartX = mouseX
                mainItem.dragStartY = mouseY
                mainItem.itemStartX = mainItem.x
                mainItem.itemStartY = mainItem.y
                xMovementInterpolator.enabled = true
                yMovementInterpolator.enabled = true
                mainItem.blockSelected(row, col)
            }
        }
        onEntered: {

        }
        onPositionChanged: {

            //if (gameBlock.canMove()) {
            var dx = mainItem.dragStartX - mouseX
            var dy = mainItem.dragStartY - mouseY
            var edx = 0
            var edy = 0
            if (Math.abs(dx) > Math.abs(dy)) {

                //mainItem.y = itemStartY;
                if (dx > (animRoot.width / 3)) {

                    movementDirection = "right"
                    edx = Math.min(animRoot.width, dx)
                }
                if (dx < (-1 * (animRoot.width / 3))) {

                    movementDirection = "left"
                    edx = Math.max(-1 * animRoot.width, dx)
                }
                if (Math.abs(edx) > 0) {
                    mainItem.x = mainItem.itemStartX - edx
                    mainItem.goingToMove(row, col, movementDirection, edx, 0)
                }
            } else {

                if (Math.abs(dx) < Math.abs(dy)) {

                    // mainItem.x = itemStartX;
                    if (dy > animRoot.height / 3) {
                        movementDirection = "down"
                        edy = Math.min(animRoot.height, dy)
                    }
                    if (dy < -1 * animRoot.height / 3) {
                        movementDirection = "up"
                        edy = Math.max(-1 * animRoot.height, dy)
                    }
                    if (Math.abs(edy) > 0) {
                        mainItem.y = itemStartY - edy
                        mainItem.goingToMove(row, col,
                                             movementDirection, 0, edy)
                    }
                }
            }
        }
        //}
        onReleased: {
            //if (gameBlock.canMove()) {
            // mainItem.x = mainItem.itemStartX
            // mainItem.y = mainItem.itemStartY
            xMovementInterpolator.enabled = false
            yMovementInterpolator.enabled = false
            mainItem.movementChanged(uuid, mainItem.movementDirection, row, col)

            //}
        }
    }

    Loader {
        id: loader
        sourceComponent: blockIdleComponent

        onLoaded: {
            itemRoot.loadFinished(itemRoot)
        }
    }

    function explode() {

        itemRoot.state = "markedForDeath"

        itemRoot.exploded(itemRoot.uuid)
        itemRoot.blockDestroyed = true
    }
    function moveBlockDown(irow, icol) {
        if (isBlockAbove(irow, icol, row, col)) {

            itemRoot.requestRowChange(row, col, (row - 1))

            //console.log("Moving block down at " + row + " " + col);
        }
    }
    function isBlockAbove(row1, col1, row2, col2) {

        if (col1 !== col2) {
            return false
        }
        if (row2 === (row1 + 1)) {
            return true
        }
        return false
    }
    function serialize() {
        var colors = ["steelblue", "gold", "firebrick", "forestgreen", "orange"]

        var availableChars = String(
                    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890ÀÁÂÃÄÅÆÇÈÉÊÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞàâãÈæçèéêëõöøùúûüýþÿĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħĨĩĪīĬĭĮįİıĲĳĴĵĶķĸĹĺĻļĽľĿŀŁłŃńŅņŇňŉŊŋŌōŎŏŐőŒœŔŕŖŗŘřŚśŜŝŞşŠšŢţŤťŦŧŨũŪūŬŭŮůŰűŲųŴŵŶŷŸŹźŻżŽžſƀƁƂƃƄƆƇƈƉƊƋƌƍƎƏƐƑƒƓƔƕƖƗƘƙƚƛƜƝƞƟƠơƢƣƤƥƦƧƨƩƪƫƬƭƮƯưƱƲƳƴƵƶƷƸƹƺ").split(
                    "")

        var msg = ""
        msg += row
        msg += ","
        msg += col
        msg += ","
        msg += colors.indexOf(blockColor)
        //        msg += ",";
        //        msg += blockStates.indexOf(itemRoot.state);
        //        msg += ",";
        //        msg += itemRoot.uuid;
        //        msg += ",";
        //        msg += blockHealth;
        //        msg += ","
        //        msg += Math.round(itemRoot.y);
        return msg
    }
    function checkBlockAssignment(i_block) {
        if (i_block === itemRoot) {
            if (i_block !== null) {
                if (itemRoot !== null) {

                    // itemRoot.state = "idle";
                }
            }
        }
    }
    function handleGridPositionRequest(irow, icol) {
        if (itemRoot !== null) {
            if (itemRoot.row === irow) {
                if (itemRoot.col === icol) {
                    provideBlockGridPosition(itemRoot.uuid, itemRoot.row,
                                             itemRoot.col)
                }
            }
        }
    }
}
