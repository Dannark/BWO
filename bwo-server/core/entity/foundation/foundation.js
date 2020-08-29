var state;
var notifyAllOnRangeOfPlayer;
var notifyAllOnRangeOfArea;
                            

export function setup(mState, mNotifyAllOnRangeOfPlayer, mNotifyAllOnRangeOfArea) {
    state = mState;
    notifyAllOnRangeOfPlayer = mNotifyAllOnRangeOfPlayer;
    notifyAllOnRangeOfArea = mNotifyAllOnRangeOfArea;
}

export function addFoundation(command){
    console.log(`Foundation Added to owner ${command.owner}`);
    state.foundations[command.owner] = {
        ...command
    }
}

export function getAllFoundationsAround(playerId) {
    var mPlayer = state.players[playerId]
    var width = 500
    var height = 700

    var foundationArray = Object.entries(state.foundations).filter((foundation) => {

        return foundation[1].x > mPlayer.x - width
            && foundation[1].y > mPlayer.y - height
            && foundation[1].x < mPlayer.x + width
            && foundation[1].y < mPlayer.y + height;
    });

    var foundationObject = Object.fromEntries(foundationArray);
    return foundationObject;
}
