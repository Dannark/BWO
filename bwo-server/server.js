//import Required libraries
import config from './resources/config.js'
import { setDatabaseConfig, isReady } from './resources/data/state_manager.js'
import startServer from './core/core_server.js'

//3. load game maps data
// const maps = {name:"main"}
// var map_files = fs.readdirSync('./resources/data/maps/')
// map_files.forEach(mapFiles => {
//     console.log('Loading map: '+mapFiles)
// });

//4. Initiate the server and listen to the internets
//all of server logic

setDatabaseConfig(config);
//wait firebabase to be ready
if (config.enviroment == 'production') {
    var interval = setInterval(() => {
        if (isReady()) {
            clearInterval(interval);
            startServer(config);
        }
    }, 1000)
}
else{
    startServer(config);
}
