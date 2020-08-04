import express from 'express'
import http from 'http'
import startServer from "./public/game.js"
import socketio from 'socket.io'

const app = express()
const server = http.createServer(app)
const sockets = socketio(server)

const game = startServer();

game.subscribe((command) => {
    console.log(`> Emitting ${command.type} (${game.state.statistics.msgRecived}) `)
    var type = command.type
    delete command.type
    sockets.emit(type, command)
})

sockets.on('connection', (socket) => {
    const playerId = socket.id;
    console.log(`Player connected: ${playerId}`)
    game.addSocket(socket)

    socket.emit('socket_info', playerId)

    socket.on('log-player', (command) => {
        //var c = JSON.parse(command);
        console.log("log-player ", command);
        game.logPlayer({ playerId: playerId, ...command })
        
        sendMessage('onPlayerEnterScreen', game.getAllPlayersAround(playerId))
    })

    socket.on('onMove', (command) => {
        game.state.statistics.msgRecived ++;
        game.updatePlayer({playerId: playerId, ...command})

        sendMessage('onPlayerEnterScreen', game.getAllPlayersAround(playerId))
        sendMessage('onEnemysEnterScreen', game.getAllEnemysAround(playerId))
    })

    socket.on('onTreeHit', (command) => {
        game.hitTree({playerId: playerId, ...command})
    })

    socket.on('onEnemyAttackPlayer', (command) => {
        game.enemyAttackPlayer(command);
    })

    socket.on('disconnect', () => {
        game.removePlayer({ playerId: playerId })
        console.log(`> Player disconnected: ${playerId}`)
    })
    
    function sendMessage(tag, obj){
        var isEmpty = Object.keys(obj).length === 0 && obj.constructor === Object
        if(isEmpty == false){
            socket.emit(tag, obj)
        }
    }
})

//app.use(express.static('public'))

app.get('/', (request, response) => {
    
    return response.json({
        version: 'v0.1'
    })
})


server.listen(3000, () => {
    console.log(`Server listeting on port: 3000`)
})