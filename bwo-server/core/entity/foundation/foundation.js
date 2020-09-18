var state;
var notifyAllOnRangeOfPlayer;
var notifyAllOnRangeOfArea;
                            

export function setup(mState, mNotifyAllOnRangeOfPlayer, mNotifyAllOnRangeOfArea) {
    state = mState;
    notifyAllOnRangeOfPlayer = mNotifyAllOnRangeOfPlayer;
    notifyAllOnRangeOfArea = mNotifyAllOnRangeOfArea;
}

export function addFoundation(command){
    console.log(`Saving Foundation of owner: ${command.owner}`);
    state.foundations[command.owner] = {
        ...command
    }

    notifyAllOnRangeOfArea({
        type: 'onAddFoundation',
        point: {x:command.x*16, y:command.y*16},
        [command.owner]:{...command}
    },false)
}

export function getAllFoundationsAroundPlayer(playerId) {
    var mPlayer = state.players[playerId]
    var width = 40
    var height = 50

    var foundationArray = Object.entries(state.foundations).filter((foundation) => {
        return foundation[1].x > mPlayer.x/16 - width
            && foundation[1].y > mPlayer.y/16 - height
            && foundation[1].x < mPlayer.x/16 + width
            && foundation[1].y < mPlayer.y/16 + height;
    });

    var foundationObject = Object.fromEntries(foundationArray);
    return foundationObject;
}

export function getAllFoundationsAroundPoint(command) {
    var left = command.x
    var top = command.y
    var right = (command.x + command.w)
    var bottom = (command.h + command.h)

    var borderSize = 2

    var foundationArray = Object.entries(state.foundations).filter((foundation) => {

        return foundation[1].x >= left - borderSize
            && foundation[1].y >= top - borderSize
            && (foundation[1].x + foundation[1].w) <= right + borderSize
            && (foundation[1].y + foundation[1].h) <= bottom + borderSize;
    });

    var foundationObject = Object.fromEntries(foundationArray);
    return foundationObject;
}