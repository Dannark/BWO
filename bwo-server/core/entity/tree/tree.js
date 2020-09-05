import moment from 'moment';

var state;
var notifyAllOnRangeOfPlayer;
var notifyAllOnRangeOfArea;

export function setup(mState, mNotifyAllOnRangeOfPlayer, mNotifyAllOnRangeOfArea) {
    state = mState;
    notifyAllOnRangeOfPlayer = mNotifyAllOnRangeOfPlayer;
    notifyAllOnRangeOfArea = mNotifyAllOnRangeOfArea;
}

export function hitTree(command) {
    var treeId = "_"+command.x+'_'+command.y;
    var tree = state.trees[treeId];
    
    if(tree == undefined){
        console.log(`> adding tree to ${command.x}, ${command.y}`)
        state.trees[treeId]={
            hp: 20,
            x: command.x,
            y: command.y
        }
        
    }
    state.trees[treeId].hp -= command.damage;
    state.trees[treeId].last_damage_stamp = moment().format();

    notifyAllOnRangeOfPlayer({
        type: 'onTreeUpdate',
        [treeId]:{
            x:command.x,
            y:command.y,
            treeId:treeId,
            hp: state.trees[treeId].hp,
            damage:command.damage,
            playerId:command.playerId
        }
    }, command.playerId, false)
}

export function getAllTreesAround(playerId) {
    var mPlayer = state.players[playerId]
    var width = 500
    var height = 700

    var treesArray = Object.entries(state.trees).filter((tree) => {
        var previousTime = tree[1].last_damage_stamp;
        var secondsPassed = moment(moment.format).diff(previousTime, 'seconds');
        tree[1].dead_time = secondsPassed;

        return tree[1].x > mPlayer.x - width
            && tree[1].y > mPlayer.y - height
            && tree[1].x < mPlayer.x + width
            && tree[1].y < mPlayer.y + height;
    });

    //deep copy, lose references so we can safely delete stuffs and dont send info that we dont need
    // var treesArrayCopy = JSON.parse(JSON.stringify(treesArray))
    // treesArrayCopy.forEach((tree) => {
    //     delete tree[1].last_damage_stamp;
    // });

    var treesObject = Object.fromEntries(treesArray);
    return treesObject;
}


//reset dead trees
setInterval(() => {
    Object.entries(state.trees).forEach(tree => {
        
        if(tree[1].hp <= 0){
            var previousTime = tree[1].last_damage_stamp;
            var secondsPassed = moment(moment.format).diff(previousTime, 'seconds');
            
            if(secondsPassed > 180){
                
                notifyAllOnRangeOfArea({
                    type: 'onTreeUpdate',
                    point:{x: tree[1].x, y: tree[1].y},
                    [tree[0]]:{
                        x:tree[1].x,
                        y:tree[1].y,
                        hp: 20 //respawn tree
                    }
                }, false)
                delete state.trees[tree[0]];
            }
        }
        else if(tree[1].hp < 20){
            var previousTime = tree[1].last_damage_stamp;
            var secondsPassed = moment(moment.format).diff(previousTime, 'seconds');

            tree[1].hp ++;
        }
        else if(tree[1].hp == 20){
            delete state.trees[tree[0]];
        }
    });
}, 5000)