import fs from 'fs'
import moment from 'moment-timezone';
import * as firebase from './firebase.js';

export function isReady() { return firebase.isReady() }

var config;
export function setDatabaseConfig(mConfig) {
    config = mConfig;
    if (config.enviroment == 'production') {
        firebase.startFirebase(mConfig.database_conf);
    }
}

let defaulState = {
    statistics: {
        msgRecived: 0,
        msgSent: 0,
    },
    players: {},
    enemys: {},
    trees: {} //cut trees
};


var defaultLogState = {
    [moment().tz("America/Sao_Paulo").format('DD_MM_YYYY')]: []
}

export function saveState(state) {
    if (config.enviroment == 'production') {
        var stateCopy = Object.assign({}, state);
        firebase.writeState(stateCopy);
    }
}

export function loadState() {
    if (config.enviroment == 'production') {
        var loadedState = Object.assign(defaulState, firebase.my_state);
        loadedState.players = {};//disconnects all players
        if (loadedState != undefined && loadedState != 'undefined' && loadedState != '') {
            defaulState = loadedState;
        }
    }
    //console.log('defaulState',defaulState);
    return defaulState;
}


export function saveLog(tag, msg) {
    if (config.enviroment == 'production') {
        var log = { time: moment().tz("America/Sao_Paulo").format('HH:mm:ss'), msg: msg };
        var log_day_folder = moment().tz("America/Sao_Paulo").format('DD_MM_YYYY');
        var log_time_id = moment().tz("America/Sao_Paulo").format('x');

        firebase.writeLog(log, log_day_folder + '/' + log_time_id);
    }
}

export function loadLog() {
    if (config.enviroment == 'production') {
        var loadedState = firebase.my_log;

        if (loadedState != undefined && loadedState != 'undefined' && loadedState != '') {
            defaultLogState = loadedState;
        }
    }
    return defaultLogState;
}