import fs from 'fs'
import moment from 'moment-timezone';
import * as firebase from './firebase_storage.js';
import * as localstore from './local_storage.js';

export function isReady() { return firebase.isReady() }

var config;
export function setDatabaseConfig(mConfig) {
    config = mConfig;
    
    if(config.environment != 'localhost'){
        firebase.setFirebaseConfig(mConfig);
    }
}

export function saveState(state) {
    if(config.environment != 'localhost'){
        firebase.saveState(state);
    }else{
        localstore.saveState(state);
    }
}

export function loadState() {
    var defaulState = {}

    if(config.environment != 'localhost'){
        defaulState = firebase.loadState();
    }
    else{
        defaulState = localstore.loadState();
    }
    return defaulState;
}


export function saveLog(tag, msg) {

    if(config.environment != 'localhost'){
        firebase.saveLog(tag, msg);
    }
    else{
        localstore.saveLog(tag, msg);
    }
}

export function loadLog() {
    var defaultLogState = {}

    if(config.environment != 'localhost'){
        defaultLogState = firebase.loadLog();
    }
    else{
        defaultLogState = localstore.loadLog();
    }
    return defaultLogState;
}