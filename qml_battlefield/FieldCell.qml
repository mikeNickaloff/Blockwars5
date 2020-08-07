import QtQuick 2.0

Rectangle {
    id: cellRoot
    property var row
    property int column
    property alias col: cellRoot.column
    color: 'black'
    border.color: 'white'
    border.width: 2
    property Block block: null
    function isEmpty() {
        if (block === null) {
            return true
        }
    }
}
