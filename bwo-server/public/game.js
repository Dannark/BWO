import * as enemysController from "./Enemys.js";

export default function startServer() {
    const state = {
        players: {},
        enemys: {},
        statistics: {
            msgRecived: 0,
            msgSent: 0,
        }
    };

    // make enemy random walk
    setInterval(() => enemysController.patrolArea(state.enemys, (enemysMoved) => {
        Object.entries(enemysMoved).forEach(enemy => {
            var mPoint = {x: enemy[1].x, y: enemy[1].y};
            notifyAllOnRangeOfArea({
                type: 'getEnemys',
                point: mPoint,
                enemys: enemysMoved
            })
        });
        
    }), 5000);

    //make enemys attack players
    setInterval(() => enemysController.attackPlayerIfInRange(state, (command) =>{
        notifyAllOnRangeOfPlayer({
            ...command,
            type: 'onEnemyTargetingPlayer',
        })
    }), 1500);

    const observers = []

    function subscribe(observerFunction) {
        observers.push(observerFunction)
    }

    function notifyAll(command) {
        for (const observerFunction of observers) {
            observerFunction(command)
        }
    }

    const socketList = []
    function addSocket(socket) {
        socketList.push(socket)
    }
    function removeSocket(id) {
        delete socketList[id]
    }
    function notifyAllOnRangeOfPlayer(command) {
        var allPlayers = getAllPlayersAround(command.playerId)
        //delete command.playerId

        for (const skt of socketList) {
            if (allPlayers[skt.id] != undefined) {
                var type = command.type
                //delete command.type
                skt.emit(type, command)
            }
        }
    }
    function notifyAllOnRangeOfArea(command) {
        //console.log(`> Emitting Optimized: ${command.type} (${state.statistics.msgRecived}) `)

        var allPlayers = getAllPlayersAroundPoint(command.point)
        delete command.point

        for (const skt of socketList) {
            if (allPlayers[skt.id] != undefined) {
                var type = command.type
                delete command.type
                skt.emit(type, command)
            }

        }
    }

    function updatePlayer(command) {
        const playerId = command.playerId
        var playerFound = state.players[playerId]
        var type = command.type
        if (playerFound != undefined) {

            state.players[command.playerId] = {
                ...command,
                x: command.x,
                y: command.y
            };

            notifyAllOnRangeOfPlayer({
                type: 'onMove',
                ...command
            })
        }
        else {
            console.log(`> player ${playerId} not found when trying to move him`)
        }

        enemysController.spawnEnemyLoop(playerFound, state.enemys, (enemyListAroundPlayer) => {
            //enemy created 
            notifyAllOnRangeOfPlayer({
                type: 'getEnemys',
                playerId: playerId,
                enemys: enemyListAroundPlayer
            })
        })
    }

    function addPlayer(command) {
        const playerId = command.playerId
        state.players[playerId] = {
            name: command.name,
            ...command,
            x: command.x,
            y: command.y
        }

        notifyAllOnRangeOfPlayer({
            type: 'add-player',
            ...command
        })

        /*notifyAll({
            type: 'add-player',
            ...command
        })*/
    }

    function removePlayer(command) {
        const playerId = command.playerId

        if (state.players[playerId] != undefined) {
            const playerName = state.players[playerId].name

            delete state.players[playerId]
            notifyAll({
                type: 'remove-player',
                playerId: playerId,
                name: playerName
            })
            removeSocket(playerId);

            var totalPlayers = Object.keys(state.players).length
            console.log(`> Players Online: ${totalPlayers}`)
        }
        else {
            console.log(`can't remove player because it dosen't exist anymore`)
        }
    }

    function logPlayer(command) {
        const playerId = command.playerId
        const playerName = command.name
        var playerFound = state.players[playerId]


        if (playerFound != undefined) {
            return playerFound;
        } else {
            console.log(`> Player ${playerId} not found, creating new player '${playerName}'`)
            addPlayer({ playerId: playerId, sprite: command.sprite, name: playerName, x: command.x, y: command.y })
            var totalPlayers = Object.keys(state.players).length
            console.log(`> Players Online: ${totalPlayers}`)
            playerFound = state.players[playerId]
        }
    }

    function getAllPlayersAround(playerId) {
        var mPlayer = state.players[playerId]
        var width = 300
        var height = 400

        var playersArray = Object.entries(state.players).filter((player) => {
            return player[1].x > mPlayer.x - width
                && player[1].y > mPlayer.y - height
                && player[1].x < mPlayer.x + width
                && player[1].y < mPlayer.y + height;
        });

        var playersObject = Object.fromEntries(playersArray);
        return playersObject;
    }

    function getAllPlayersAroundPoint(point) {
        var width = 300
        var height = 400

        var playersArray = Object.entries(state.players).filter((player) => {
            return player[1].x > point.x - width
                && player[1].y > point.y - height
                && player[1].x < point.x + width
                && player[1].y < point.y + height;
        });

        var playersObject = Object.fromEntries(playersArray);
        return playersObject;
    }

    function getAllEnemysAround(playerId){
        var mPlayer = state.players[playerId]
        var width = 300
        var height = 400

        var enemyListAroundPlayer = enemysController.getEnemysAroundPlayer(mPlayer, state.enemys, width, height)

        return enemyListAroundPlayer;
    }

    function hitTree(command) {
        notifyAllOnRangeOfPlayer({
            ...command,
            type: 'onTreeHit',
        })
    }

    return {
        hitTree,
        logPlayer,
        updatePlayer,
        getAllPlayersAround,
        removePlayer,
        getAllEnemysAround,
        subscribe,
        state,
        addSocket,
    }
}

