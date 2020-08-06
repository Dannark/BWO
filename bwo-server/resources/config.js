import minimist from 'minimist';
import extend from 'extend';
import {resetState} from '../resources/data/state_manager.js'

const args = minimist(process.argv.slice(2));

var envivoriment = args.env || 'development'
var reset_state = args.resetstate || false

if(reset_state) resetState()

var common_conf = {
    name: "Borderless World Online - MMO Game Server",
    version: "0.0.1",
    enviroment: envivoriment,
    max_players: 100,
    seed: "0"
}

//Enviroment Specific Configuration
var conf = {
    production:{
        ip: args.ip || "0.0.0.0",
        port: args.port || "3000",
        database: "mongodb://127.0.0.1/bwo_prod"
    },
    development:{
        ip: args.ip || "0.0.0.0",
        port: args.port || "3000",
        database: "mongodb://127.0.0.1/bwo_test"
    }
}

extend(false, conf.production, common_conf)
extend(false, conf.development, common_conf)

const config = conf[envivoriment]
export default config;