import fs from 'fs'

let defaulState = {
    players: {},
    enemys: {},
    statistics: {
        msgRecived: 0,
        msgSent: 0,
    }
};

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