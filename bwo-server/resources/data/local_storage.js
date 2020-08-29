import fs from 'fs'
import moment from 'moment-timezone';

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
    createdAt: moment().tz("America/Sao_Paulo").format('DD/MM/YYYY'),
    logs:[]
}

export function saveState(state) {
    //console.log("saving state ",state);
    var stateCopy = Object.assign({}, state); 
    stateCopy.players = {};
    fs.writeFile('./resources/data/tmp/game-state.json', JSON.stringify(stateCopy),  (err) => {
        if (err) throw err;
        if(err != null){
            console.log('The file has NOT been saved!', err);
        }
    });
}


export function loadState() {
    var loadedState = fs.readFileSync('./resources/data/tmp/game-state.json', 'utf8');
    //console.log("> Loaded previous state as: " + loadedState);

    if(loadedState != undefined && loadedState != 'undefined' && loadedState != ''){
        defaulState = JSON.parse(loadedState);
    }
    
    return defaulState;
}

export function resetState() {
    console.log("> Reseting state: ");
    fs.writeFile('./resources/data/tmp/game-state.json', JSON.stringify(defaulState),  (err) => {
        if (err) throw err;
        if(err != null){
            console.log('The file has NOT been saved!', err);
        }
    });
}


export function saveLog(tag, msg) {
    //console.log("saving state ",state);
    var stateCopy = Object.assign({}, defaultLogState); 
    stateCopy.logs = [
        ...stateCopy.logs,
        {time: moment().tz("America/Sao_Paulo").format('HH:mm:ss'), msg: msg}
    ];

    fs.writeFile(`./resources/data/tmp/server-log${moment().tz("America/Sao_Paulo").format('_DD-MM-YYYY')}.json`, JSON.stringify(stateCopy),  (err) => {
        if (err) throw err;
        if(err != null){
            console.log('The file has NOT been saved!', err);
        }
    });
}
export function loadLog(){
    var loadedState;
    try {
        var loadedState = fs.readFileSync(`./resources/data/tmp/server-log${moment().tz("America/Sao_Paulo").format('_DD-MM-YYYY')}.json`, 'utf8');
    } catch (err) {
        if (err.code === 'ENOENT') {
            //console.log('File not found!');
            var file_name = 'server-log'+moment().tz("America/Sao_Paulo").format('_DD-MM-YYYY')+'.json';
            console.log(`Creating the log ${file_name}`);

            fs.writeFile(`./resources/data/tmp/${file_name}`, JSON.stringify(defaultLogState),  (err) => {
                if (err) throw err;
                if(err != null){
                    console.log('The file has NOT been saved!', err);
                }
            });
        } else {
            throw err;
        }
    }
    
    if(loadedState != undefined && loadedState != 'undefined' && loadedState != ''){
        defaultLogState = JSON.parse(loadedState);
    }

    return defaultLogState;
}