import QtQuick 2.0

Item {
    id: field

    property var columnCount: 6
    property var rowCount: 6
    property var fieldCells: []
    property var blockPool: []

    property var nickname

    property var fieldCellComponent: Component {
        FieldCell {}
    }

    property var blockComponent: Component {
        Block {}
    }
    signal notifiedGameEngine(var i_targetNick, var i_cmd, var i_args)
    anchors.fill: parent
    Component.onCompleted: {
        for (var i = 0; i < 6; i++) {
            for (var u = 0; u < 6; u++) {
                var newComp = fieldCellComponent.createObject(field)
                newComp.row = i
                newComp.column = u
                setupCellGeometry(newComp, field)
                fieldCells.push(newComp)
            }
        }


        /*  console.log(fieldCells.map(function (item) {
            return [item.x, item.y, item.width, item.height]
        })) */
    }

    function makeIndex(row, col) {
        var rv = row * 6
        rv += col
        return rv
    }

    function setupCellGeometry(i_cell, i_container) {
        var geom = p_calculateGeometry(i_cell.row, i_cell.column, rowCount,
                                       columnCount, field.width, field.height)

        /*console.log(JSON.stringify(geom)) */
        i_cell.x = geom.x
        i_cell.y = geom.y
        i_cell.width = geom.width
        i_cell.height = geom.height
    }
    function setupBlockGeometry(i_block) {
        var geom = p_calculateGeometry(i_block.row, i_block.col, rowCount,
                                       columnCount, field.width, field.height)

        /*console.log(JSON.stringify(geom)) */
        i_block.x = geom.x
        i_block.y = geom.y
        i_block.width = geom.width
        i_block.height = geom.height
    }
    function p_calculateGeometry(row, col, rowCount, colCount, containerWidth, containerHeight) {
        var obj = {}
        obj.width = Math.ceil(containerWidth / colCount)
        obj.height = containerHeight / rowCount
        obj.x = obj.width * col
        obj.y = obj.height * row
        return obj
    }

    function notifyPlayerField(i_nick, i_cmd, in_args) {
        if (i_nick === field.nickname) {
            console.log("Received player field commmand", i_nick,
                        i_cmd, in_args)
            if (i_cmd === "createBlockInField") {
                var i_args = in_args.split("$")
                var uuid = i_args.shift()
                var block_color = i_args.shift()
                var health = i_args.shift()
                var row = i_args.shift()
                var col = i_args.shift()
                var frozen_rounds = i_args.shift()
                var burning_rounds = i_args.shift()
                var invulnerable_rounds = i_args.shift()
                var block_destroyed = i_args.shift() === "false" ? false : true
                var hero = i_args.shift()
                var block_instance = blockComponent.createObject(field)

                block_instance.blockColor = block_color
                block_instance.row = row
                block_instance.col = col
                block_instance.frozenRounds = frozen_rounds
                block_instance.burningRounds = burning_rounds
                block_instance.invulnerableRounds = invulnerable_rounds
                block_instance.blockHealth = health
                block_instance.blockDestroyed = block_destroyed
                block_instance.hero = hero
                block_instance.uuid = uuid
                block_instance.movementChanged.connect(
                            field.handleMovementRequest)
                setupBlockGeometry(block_instance)
                block_instance.exploded.connect(
                            field.handleBlockExplosionRequestFromBlock)

                blockPool.push(block_instance)
                //block_instance.x = fieldCells[makeIndex(row, col)].x
                //block_instance.y = fieldCells[makeIndex(row, col)].y
            }
            if (i_cmd === "updateBlockField") {
                var i_args = in_args.split("$")
                var uuid = i_args.shift()
                var block_color = i_args.shift()
                var health = i_args.shift()
                var row = i_args.shift()
                var col = i_args.shift()
                var frozen_rounds = i_args.shift()
                var burning_rounds = i_args.shift()
                var invulnerable_rounds = i_args.shift()
                var block_destroyed = i_args.shift() === "false" ? false : true
                var hero = i_args.shift()
                var matchingBlocks = blockPool.filter(function (item) {
                    if (item.uuid === uuid) {
                        return true
                    } else {
                        return false
                    }
                })
                if (matchingBlocks.length > 0) {
                    matchingBlocks.forEach(function (block_instance) {
                        block_instance.blockColor = block_color
                        block_instance.row = row
                        block_instance.col = col
                        block_instance.frozenRounds = frozen_rounds
                        block_instance.burningRounds = burning_rounds
                        block_instance.invulnerableRounds = invulnerable_rounds
                        block_instance.blockHealth = health
                        block_instance.blockDestroyed = block_destroyed
                        block_instance.hero = hero
                        setupBlockGeometry(block_instance)
                    })
                }
            }
        } else {

            //   console.log("Ignored player field commmand", i_nick, i_cmd, in_args)
            // do nothing because the command was not meant for this field to process
            // based on i_nick
        }
    }

    function handleMovementRequest(uuid, direction, row, col) {

        console.log("movement req : " + direction + " " + row + " " + col)
        var newRow = row
        var newCol = col
        if (direction === "up") {
            row++
        }
        if (direction === "left") {
            col++
        }
        if (direction === "right") {
            col--
        }
        if (direction === "down") {
            row--
        }
        var swapdata = [row, col, newRow, newCol]
        notifiedGameEngine(nickname, "swap", swapdata.join(" "))
    }

    function handleBlockExplosionRequestFromBlock(i_uuid) {
        notifiedGameEngine(nickname, "destroyedBlock", i_uuid)
    }
}
