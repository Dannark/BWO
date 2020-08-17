//import Required libraries
import fs from 'fs'
import startServer from './core/core_server.js'

//3. load game maps data
// const maps = {name:"main"}
// var map_files = fs.readdirSync('./resources/data/maps/')
// map_files.forEach(mapFiles => {
//     console.log('Loading map: '+mapFiles)
// });

//4. Initiate the server and listen to the internets
    //all of server logic
startServer();