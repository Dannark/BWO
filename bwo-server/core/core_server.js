import moment from 'moment';
import express from 'express'
import http from 'http'
import game_server from "./game.js"
import socketio from 'socket.io'
import {loadLog, saveLog} from '../resources/data/state_manager.js'

export default function startServer (config) {
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
        //console.log(`Player on lobby: ${playerId}`)
        game.addSocket(socket)

        var lastMoveUpdateTime = moment().format();

        socket.emit('onSetup', playerId)

        socket.on('log-player', (command) => {
            game.state.statistics.msgRecived ++;
            saveLog('server-info',`Player connected: ${command.name}, sprite: '${command.sprite}' at (x: ${parseInt(command.x)}, y: ${parseInt(command.y)}) id:${playerId}`);
            //var c = JSON.parse(command);
            console.log("log-player ", command);
            game.playerController.logPlayer({ playerId: playerId, ...command })
            
            socket.emit('onPlayerEnterScreen', game.getAllPlayersAround(playerId))
            socket.emit('onEnemysEnterScreen', game.getAllEnemysAround(playerId))
            sendMessageIfNotEmpty('onTreeUpdate', game.treeController.getAllTreesAround(playerId))
            socket.emit('onAddFoundation', game.foundationController.getAllFoundationsAround(playerId))
        })

        socket.on('onMove', (command) => {
            game.state.statistics.msgRecived ++;
            
            game.playerController.movePlayer({playerId: playerId, ...command})

            sendMessageIfNotEmpty('onPlayerEnterScreen', game.getAllPlayersAround(playerId))
            socket.emit('onEnemysEnterScreen', game.getAllEnemysAround(playerId))

            if(isReadyToUpdate(lastMoveUpdateTime, 1000)){//send update with limited time
                lastMoveUpdateTime = moment().format();
                sendMessageIfNotEmpty('onTreeUpdate', game.treeController.getAllTreesAround(playerId))
                socket.emit('onAddFoundation', game.foundationController.getAllFoundationsAround(playerId))
            }
        })

        socket.on('onUpdate', (command) => {
            game.state.statistics.msgRecived ++;

            if(command.action == 'reviving'){
                game.playerController.respawn({playerId: playerId, ...command});
                socket.emit('onEnemysEnterScreen', game.getAllEnemysAround(playerId))
            }
            else{
                game.playerController.updatePlayer({playerId: playerId, ...command})
            }
        })

        socket.on('onTreeHit', (command) => {
            game.state.statistics.msgRecived ++;

            game.treeController.hitTree({playerId: playerId, ...command})
        })

        socket.on('onFoundationAdd', (command) => {
            game.state.statistics.msgRecived ++;
            console.log('onFoundationAdd');
            game.foundationController.addFoundation({playerId: playerId, ...command});
        })

        socket.on('onPlayerAttackEnemy', (command) => {
            game.state.statistics.msgRecived ++;

            game.playerController.attackEnemy({playerId: playerId, ...command})
        })

        socket.on('disconnect', () => {
            game.state.statistics.msgRecived ++;
            game.playerController.removePlayer({ playerId: playerId })
            console.log(`> Player disconnected: ${playerId}`)
            //saveLog('server-info',`Player disconnected: ${playerId}`);
        })

        game.playerController.update(playerId);


        // -- helper functions
        
        function sendMessageIfNotEmpty(tag, obj){
            game.state.statistics.msgSent ++;
            var isEmpty = Object.keys(obj).length === 0 && obj.constructor === Object
            if(isEmpty == false){
                socket.emit(tag, obj)
            }
        }

        
        function isReadyToUpdate(previousTime, miliseconds){
            var milisecondsPassed = moment(moment.format).diff(previousTime, 'miliseconds');
            var isReady = milisecondsPassed >= miliseconds;
            return isReady;
        }
    })

    //app.use(express.static('public'))

    app.get('/', (request, response) => {
        saveLog('server-info',`Requested ./ from web.`);
        return response.json({
            server_name: config.name,
            version: config.version,
            players_online: Object.entries(game.state.players).length,
            enemys_spawned: Object.entries(game.state.enemys).length,
            state:game.state,

        })
    })

    app.get('/log', (request, response) => {
        saveLog('server-info',`Requested ./Log from web.`);
        return response.json({
            ...loadLog()
        })
    })

    server.listen(config.port, () => {
        saveLog('server-status','server started successfully');
        console.log(`Server running on port: ${config.port} in [${config.environment}] mode.`)
    })
}