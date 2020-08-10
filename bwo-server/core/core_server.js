import config from '../resources/config.js'
import express from 'express'
import http from 'http'
import game_server from "./game.js"
import socketio from 'socket.io'

export default function startServer () {
    const app = express()
    const server = http.createServer(app)
    const sockets = socketio(server)

    const game = game_server();

    game.subscribe((command) => {
        console.log(`> Emitting to All ${command.type} (${game.state.statistics.msgRecived}) `)
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
            game.state.statistics.msgRecived ++;
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
            game.state.statistics.msgRecived ++;
            game.hitTree({playerId: playerId, ...command})
        })

        socket.on('onEnemyAttackPlayer', (command) => {
            game.state.statistics.msgRecived ++;
            game.enemyAttackPlayer(command);
        })

        socket.on('disconnect', () => {
            game.state.statistics.msgRecived ++;
            game.removePlayer({ playerId: playerId })
            console.log(`> Player disconnected: ${playerId}`)
        })
        
        function sendMessage(tag, obj){
            game.state.statistics.msgSent ++;
            var isEmpty = Object.keys(obj).length === 0 && obj.constructor === Object
            if(isEmpty == false){
                socket.emit(tag, obj)
            }
        }
    })

    //app.use(express.static('public'))

    app.get('/', (request, response) => {
        
        return response.json({
            server_name: config.name,
            version: config.version,
            statistics:{
                players_online: Object.entries(game.state.players).length,
                enemys_spawned: Object.entries(game.state.enemys).length,
                msg_recived: game.state.statistics.msgRecived,
                msg_sent: game.state.statistics.msgSent
            }

        })
    })

    server.listen(config.port, () => {
        console.log(`Server running on port: ${config.port} in [${config.enviroment}] mode.`)
    })
}