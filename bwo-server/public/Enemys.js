import lerp from 'lerp';

export function spawnEnemyLoop(player, enemyList, callback){
    if(Math.random() < .08){//.05
        var enemyListAroundPlayer = getEnemysAroundPlayer(player, enemyList, 300, 400)
        var enemysAmount = Object.keys(enemyListAroundPlayer).length
        
        if(enemysAmount < 1){//2
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
        x: (player.x - offSetX),
        y: (player.y - offSetY),
        toX: (player.x - offSetX),
        toY: (player.y - offSetY)
    }
    enemyList[enemyId] = enemy;
    enemyListAroundPlayer[enemyId] = enemy;
    //var totalEnemys = Object.keys(enemyList).length
    if(parseInt((enemy.x)/16) == NaN || parseInt((enemy.x)/16) == null){
        console.log(`> ${player.x} ${offSetX} `);
    }
    console.log(`> Spawning ${enemy.name} ${parseInt((enemy.x)/16)}, ${parseInt((enemy.y)/16)} `, enemy.x, enemy.y);
    callback(enemyListAroundPlayer);
}

export function getEnemysAroundPlayer(mPlayer, enemyList, width, height) {

    var enemyListArray = Object.entries(enemyList).filter((enemy) => {

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
    Object.entries(state.players).forEach(player => {
        var enemyListAroundPlayer = getEnemysAroundPlayer(player[1], state.enemys, 150, 150)
        
        Object.entries(enemyListAroundPlayer).forEach(element => {
            var distance = getDistance(element[1], player[1]);
            console.log(distance, `e: ${element[1].x}, ${element[1].y}`, `p: ${player[1].x}, ${player[1].y}`);
            if(distance < 128){
                state.enemys[element[0]] = {
                    ...state.enemys[element[0]],
                    target: player[1].playerId
                }
                
            }
            else{
                //lose target
                if(state.enemys[element[0]].target != undefined){
                    console.log("lose target")
                    //delete state.enemys[element[0]].target;
                }
            }

            /*if(distance < 32){
                //send damage
                enemyListAroundPlayer[element[0]] ={
                    ...enemyListAroundPlayer[element[0]],
                    damage: element[1].force + parseInt(Math.random() * 2)
                }
            }*/
        });

        if(Object.entries(enemyListAroundPlayer).length > 0){
            callback({playerId:player[1].playerId, enemys:enemyListAroundPlayer});
        }
    });

}

function loseTargetIfNotInRange(state, enemy){
    if(enemy.target != undefined){
        var playerTargeted = state.players[enemy.target]
        
        if(playerTargeted != undefined){
            var distance = getDistance(enemy, playerTargeted);
            if(distance > 192){
                delete enemy.target;
            }
        }
    }
}

let enemysToBeMoved = []

export function patrolArea(state, callback){
    var patrolAreaRange = 300;
    
    var enemysMoved = {};
    
    Object.entries(state.enemys).forEach(enemy => {
        if(Math.random() < .3){//.3
            if(enemy[1].target == undefined){
                //enemy[1].x += parseInt((Math.random() * patrolAreaRange) - patrolAreaRange/2);
                //enemy[1].y += parseInt((Math.random() * patrolAreaRange) - patrolAreaRange/2);
                let toX = enemy[1].x + (parseInt((Math.random() * patrolAreaRange) - patrolAreaRange/2));
                let toY = enemy[1].y + (parseInt((Math.random() * patrolAreaRange) - patrolAreaRange/2));
                
                enemy[1].toX = toX;
                enemy[1].toY = toY;
                
                enemysToBeMoved = [
                    ...enemysToBeMoved,
                    enemy[0]
                ]

                enemysMoved[enemy[0]] = {
                    ...enemy[1]
                }
            }
        }
    });
    callback(enemysMoved);
}

export function simulateMove(state){
    
    enemysToBeMoved.forEach(enemyCached => {
        var enemy = state.enemys[enemyCached]
        
        var point = {x: enemy.toX, y: enemy.toY}

        var distance = getDistance(enemy, point);
        //console.log(`${enemy.name} walking...`, distance)
        enemy.x += clamp(point.x - enemy.x, -30, 30)
        enemy.y += clamp(point.y - enemy.y, -30, 30)

        if(distance < 16){
            enemy.x = point.x;
            enemy.y = point.y;
            enemysToBeMoved.splice(enemysToBeMoved.indexOf(enemyCached), 1);
        }
    });
}

function getDistance(p1, p2){
    var a = p1.x - p2.x;
    var b = p1.y - p2.y;

    return Math.sqrt( a*a + b*b );
}

function clamp(num, min, max) {
    return num <= min ? min : num >= max ? max : num;
  }