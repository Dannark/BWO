const io = require('socket.io-client');
const socket = io('ws://localhost:3000');

var onPlayerEnterScreen;

var open = function (callback) {

    socket.on('connect', () => {
        console.log(socket.connected);
        callback(socket.connected)

    });

    socket.on('disconnect', () => {
        console.log(socket.connected);
    });

    socket.on('connect_error', () => {
        console.log("connect_error");
        callback(socket.connected)
    });

    socket.on('onPlayerEnterScreen', (data) => {
        if(onPlayerEnterScreen != null){
            onPlayerEnterScreen(data)
            onPlayerEnterScreen = null;
        }
    });

};

var login = function (player, callback) {
    socket.emit('log-player', player);
    callback(true)
}

var disconnect = () => {
    if (socket.connected)
        socket.disconnect();
}

var move = function (player, callback) {
    onPlayerEnterScreen = callback;
    socket.emit('onMove', player);

    setTimeout(function () { 
        if(onPlayerEnterScreen != null){
            callback({});
            onPlayerEnterScreen = null;
        }
    }, 300);
}

var attackEnemy = function (){
    
}

module.exports = { open, login, disconnect, move };