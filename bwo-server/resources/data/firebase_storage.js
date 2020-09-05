import fs from 'fs'
import moment from 'moment-timezone';
import * as firebase from './firebase.js';

export function isReady() { return firebase.isReady() }

var config;
export function setFirebaseConfig(mConfig) {
    config = mConfig;
    firebase.startFirebase(mConfig);
}

let defaulState = {
    statistics: {
        msgRecived: 0,
        msgSent: 0,
    },
    players: {},
    enemys: {},
    trees: {}, //cut trees
    foundations: {}
};


var defaultLogState = {
    [moment().tz("America/Sao_Paulo").format('DD_MM_YYYY')]: []
}

export function saveState(state) {
    //var stateCopy = Object.assign({}, state);
    var mergedData = {}

    Object.entries(state.players).forEach((player) => {
        var p = {...player[1]};
        delete p.playerId;
        
        mergedData[`players/${p.name}`] = {...p};
    })

    Object.entries(state.trees).forEach((tree) => {
        var t = {...tree[1]};
        
        mergedData[`trees/${tree[0]}`] = t;
    })

    Object.entries(state.statistics).forEach((msg) => {
        mergedData[`statistics/${msg[0]}`] = msg[1];
    })
    
    Object.entries(state.foundations).forEach((fondation) => {
        var f = {...fondation[1]};
        
        mergedData[`foundations/${f.owner}`] = {...f};
    })
    firebase.writeState(mergedData);
}

export function loadState() {
    var loadedState = Object.assign(defaulState, firebase.my_state);
    loadedState.players = {};//disconnects all players
    if (loadedState != undefined && loadedState != '') {
        defaulState = loadedState;
    }
    //console.log('defaulState',defaulState);
    return defaulState;
}


export function saveLog(tag, msg) {
    var log = { time: moment().tz("America/Sao_Paulo").format('HH:mm:ss'), msg: msg };
    var log_day_folder = moment().tz("America/Sao_Paulo").format('DD_MM_YYYY');
    var log_time_id = moment().tz("America/Sao_Paulo").format('x');

    firebase.writeLog(log, log_day_folder + '/' + log_time_id);
}

export function loadLog() {
    var loadedState = firebase.my_log;

    if (loadedState != undefined && loadedState != 'undefined' && loadedState != '') {
        defaultLogState = loadedState;
    }
    return defaultLogState;
}