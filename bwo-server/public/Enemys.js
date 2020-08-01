export function patrolArea(enemyList, callback){
    var patrolAreaRange = 300;
    
    var enemysMoved = {};
    
    Object.entries(enemyList).forEach(enemy => {
        if(Math.random() < .3){
            enemy[1].x += parseInt((Math.random() * patrolAreaRange) - patrolAreaRange/2);
            enemy[1].y += parseInt((Math.random() * patrolAreaRange) - patrolAreaRange/2);
            
            enemysMoved[enemy[0]] = {
                ...enemy[1]
            }
        }
    });
    callback(enemysMoved);
}

export function spawnEnemyLoop(player, enemyList, callback){
    if(Math.random() < .05){
        var enemyListAroundPlayer = getEnemysAroundPlayer(player, enemyList, 300, 400)
        var enemysAmount = Object.keys(enemyListAroundPlayer).length
        
        if(enemysAmount < 2){
            spawnEnemy(player, enemyList, enemyListAroundPlayer, callback)
        }
    }
}

function spawnEnemy(player, enemyList, enemyListAroundPlayer, callback){
    if (player == null) {
        console.log('player cant be null - ignoring spawn enemy');
        return;
    }

    var offSetX = 0;
    var offSetY = 0;
    var width = 15;
    var height = 25;
    
    if(Math.abs(player.xSpeed) > Math.abs(player.ySpeed)){
        if(player.xSpeed < 0){
            offSetX = -width*16
        }
        else{
            offSetX = width*16
        }
        offSetY = (player.ySpeed * 10)*16;
    }
    else{
        if(player.ySpeed < 0){
            offSetY = -height*16
        }
        else{
            offSetY = height*16
        }
        offSetX = (player.xSpeed * 10)*16;
    }
    
    var enemyId = getRandomID ();
    var enemy = {
        enemyId: enemyId,
        name: "Skull",
        lv: 1,
        force:1,
        x: (player.x - offSetX),
        y: (player.y - offSetY)
    }
    enemyList[enemyId] = enemy;
    enemyListAroundPlayer[enemyId] = enemy;
    //var totalEnemys = Object.keys(enemyList).length
    console.log(`> Spawning ${enemy.name} ${parseInt((enemy.x)/16)}, ${parseInt((enemy.y)/16)}`);
    callback(enemyListAroundPlayer);
}

export function getEnemysAroundPlayer(mPlayer, enemyList, width, height) {

    var enemyListArray = Object.entries(enemyList).filter((enemy) => {
        var distance = getDistance(
                {x: enemy[1].x, y: enemy[1].y},
                {x: mPlayer.x, y: mPlayer.y});

        return enemy[1].x > mPlayer.x - width
            && enemy[1].y > mPlayer.y - height
            && enemy[1].x < mPlayer.x + width
            && enemy[1].y < mPlayer.y + height;
    });
    
    var enemysObject = Object.fromEntries(enemyListArray);
    return enemysObject;
}

function getRandomID () {
  return '_' + Math.random().toString(36).substr(2, 9);
};

/* ATTACK LOGIC */
export function attackPlayerIfInRange(state, callback){

    var playersArray = Object.entries(state.players).forEach(player => {
        var enemyListAroundPlayer = getEnemysAroundPlayer(player[1], state.enemys, 150, 150)
        
        Object.entries(enemyListAroundPlayer).forEach(element => {
            var distance = getDistance(element[1], player[1]);
            
            state.enemys[element[0]] = {
                ...state.enemys[element[0]],
                target: player[1].playerId
            }

            if(distance < 32){
                //send damage
                enemyListAroundPlayer[element[0]] ={
                    ...enemyListAroundPlayer[element[0]],
                    damage: element[1].force + parseInt(Math.random() * 2)
                }
            }
        });

        if(Object.entries(enemyListAroundPlayer).length > 0){
            callback({playerId:player[1].playerId, enemys:enemyListAroundPlayer});
        }
    });

}

function getDistance(p1, p2){
    var a = p1.x - p2.x;
    var b = p1.y - p2.y;

    return Math.sqrt( a*a + b*b );
}