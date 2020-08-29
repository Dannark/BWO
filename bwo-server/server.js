//import Required libraries
import config from './resources/config.js'
import { setDatabaseConfig, isReady } from './resources/data/state_manager.js'
import startServer from './core/core_server.js'

setDatabaseConfig(config);

//wait firebabase to be ready
if (config.environment == 'production' || config.environment == 'development') {
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