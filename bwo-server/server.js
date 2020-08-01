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
        console.log("log-player");
        game.logPlayer({ playerId: playerId, ...command })
        
        socket.emit('onReceivedPlayersOnScreen', game.getAllPlayersAround(playerId))
    })

    socket.on('onMove', (command) => {
        game.state.statistics.msgRecived ++;
        game.updatePlayer({playerId: playerId, ...command})

        socket.emit('onReceivedPlayersOnScreen', game.getAllPlayersAround(playerId))
        socket.emit('onReceivedEnemysOnScreen', game.getAllEnemysAround (playerId))
    })

    socket.on('onTreeHit', (command) => {
        console.log("onTreeHit")
        game.hitTree({playerId: playerId, ...command})
    })

    socket.on('disconnect', () => {
        game.removePlayer({ playerId: playerId })
        console.log(`> Player disconnected: ${playerId}`)
    })
})

//app.use(express.static('public'))

app.get('/map', (request, response) => {
    
})

app.get('/', (request, response) => {
    
    return response.json({
        version: 'v0.1'
    })
})


server.listen(3000, () => {
    console.log(`Server listeting on port: 3000`)
})