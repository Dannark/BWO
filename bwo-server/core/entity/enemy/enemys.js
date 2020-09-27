import lerp from 'lerp';
import moment from 'moment';

export function spawnEnemyLoop(player, enemyList, callback) {
    if (Math.random() < .08) {//.05
        var enemyListAroundPlayer = getEnemysAroundPlayer(player, enemyList, 300, 400)
        var enemysAmount = Object.keys(enemyListAroundPlayer).length

        if (enemysAmount < 1) {//2
            spawnEnemy(player, enemyList, enemyListAroundPlayer, callback)
        }
    }
}

function spawnEnemy(player, enemyList, enemyListAroundPlayer, callback) {
    if (player == null) {
        console.log('player cant be null - ignoring spawn enemy');
        return;
    }

    var offSetX = 0;
    var offSetY = 0;
    var width = 15;
    var height = 25;

    var xSpeed = player.xSpeed ? player.xSpeed : 0
    var ySpeed = player.ySpeed ? player.ySpeed : 0

    if (Math.abs(xSpeed) > Math.abs(ySpeed)) {
        if (xSpeed < 0) {
            offSetX = -width * 16
        }
        else {
            offSetX = width * 16
        }
        offSetY = (ySpeed * 10) * 16;
    }
    else {
        if (ySpeed < 0) {
            offSetY = -height * 16
        }
        else {
            offSetY = height * 16
        }
        offSetX = (xSpeed * 10) * 16;
    }

    var enemyId = getRandomID();
    var enemy = {
        enemyId: enemyId,
        name: "Skull",
        x: (player.x - offSetX),
        y: (player.y - offSetY),
        toX: (player.x - offSetX),
        toY: (player.y - offSetY),
        hp: 6,
        lv: 1
    }
    enemyList[enemyId] = enemy;
    enemyListAroundPlayer[enemyId] = enemy;
    //var totalEnemys = Object.keys(enemyList).length
    if (isNaN(parseInt((enemy.x) / 16)) || parseInt((enemy.x) / 16) == null) {
        console.log(`> ${player.x} ${offSetX} `, player, (width * 16));
    }
    console.log(`> Spawning x:${enemy.name} y:${parseInt((enemy.x) / 16)}, ${parseInt((enemy.y) / 16)} `, enemy.x, enemy.y);
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

function getRandomID() {
    return '_' + Math.random().toString(36).substr(2, 9);
};

/* ATTACK LOGIC */
export function attackPlayerIfInRange(state, callback) {
    Object.entries(state.players).forEach(player => {

        if (state.players[player[0]].hp > 0) {
            var enemyListAroundPlayer = getEnemysAroundPlayer(player[1], state.enemys, 164, 164)

            Object.entries(enemyListAroundPlayer).forEach(element => {

                //dont switch the target if there is one already
                if (state.enemys[element[0]].target == player[1].playerId || state.enemys[element[0]].target == undefined) {
                    if (isInsideFoundation(state, player[1])) {
                        console.log('avoid target becase it is inside foundation');
                        return;
                    }
                    var distance = getDistance(element[1], player[1]);

                    state.enemys[element[0]] = {
                        ...state.enemys[element[0]],
                        toX: player[1].x,
                        toY: player[1].y,
                        target: player[1].playerId
                    }

                    enemysToBeMoved.add(element[0])

                    if (distance <= 16 && state.players[player[0]].hp > 0) {
                        var damage = element[1].name == 'Skull' ? 2 : 0;

                        damage += parseInt(Math.random() * 2);

                        var readyToSendDamage = true;
                        if (state.enemys[element[0]].last_damage_stamp != undefined) {
                            var previousTime = state.enemys[element[0]].last_damage_stamp;
                            var milisecondsPassed = moment(moment.format).diff(previousTime, 'miliseconds');

                            if (milisecondsPassed >= 1500) {
                                //attack again
                                readyToSendDamage = true;
                            }
                            else {
                                readyToSendDamage = false;
                            }
                        }


                        if (readyToSendDamage) {
                            //update state
                            state.enemys[element[0]] = {
                                ...state.enemys[element[0]],
                                last_damage_stamp: moment().format()
                            }
                            state.players[player[0]].hp -= damage;

                            //send damage
                            enemyListAroundPlayer[element[0]] = {
                                ...enemyListAroundPlayer[element[0]],
                                damage: damage,
                                target_hp: state.players[player[0]].hp
                            }
                        }
                    }
                }
                else {
                    var playerSelected = state.players[state.enemys[element[0]].target];
                    if (playerSelected == undefined) {
                        console.log('deleting target from enemy becase it doesnt exists anymore');
                        delete state.enemys[element[0]].target;
                    }
                }

            });

            if (Object.entries(enemyListAroundPlayer).length > 0) {
                callback({ enemys: enemyListAroundPlayer }, player[1].playerId);
            }

            //lose target after sending damage
            Object.entries(enemyListAroundPlayer).forEach(element => {
                if (state.players[player[0]].hp <= 0) {
                    delete state.enemys[element[0]].target;
                }
            });
        }
    });

}

let enemysToBeMoved = new Set()

export function patrolArea(state, callback) {
    var patrolAreaRange = 300;

    var enemysMoved = {};

    Object.entries(state.enemys).forEach(enemy => {
        if (Math.random() < .3) {//.3
            if (enemy[1].target == undefined) {
                let toX = enemy[1].x + (parseInt((Math.random() * patrolAreaRange) - patrolAreaRange / 2));
                let toY = enemy[1].y + (parseInt((Math.random() * patrolAreaRange) - patrolAreaRange / 2));

                enemy[1].toX = toX;
                enemy[1].toY = toY;

                enemysToBeMoved.add(enemy[0])

                enemysMoved[enemy[0]] = {
                    ...enemy[1]
                }
            }
        }
    });

    if (Object.entries(state.enemys).length > 0) {
        callback(enemysMoved);
    }
}

export function simulateMove(state, callback) {

    enemysToBeMoved.forEach(enemyCached => {
        let enemy = state.enemys[enemyCached]

        if (enemy == undefined || enemy.hp <= 0) {
            console.log('Enemy is dead. Removing from simulate Move list.');
            enemysToBeMoved.delete(enemyCached);
            return;
        }

        var point = { x: enemy.toX, y: enemy.toY }
        if (enemy.target != undefined) {
            let target = state.players[enemy.target];
            if (target == undefined) {
                console.log('player target logged off, deleting it from enemy target', enemy.target, state.players[enemy.target]);
                enemysToBeMoved.delete(enemyCached);
                delete state.enemys[enemyCached].target;
                return;
            }
            else {
                if (isInsideFoundation(state, target)) {
                    enemy.toX = enemy.x;
                    enemy.toY = enemy.y;
                    enemysToBeMoved.delete(enemyCached);
                    delete state.enemys[enemyCached].target;
                    return;
                }
            }
            point = { x: target.x, y: target.y }; //crashing a lot when player leave: TypeError: Cannot read property 'x' of undefined
        }

        let distance = getDistance(enemy, point);

        //distance > 0 ? console.log(`${enemy.name} walking...`, distance) : null

        enemy.x += clamp(point.x - enemy.x, -24, 24)
        enemy.y += clamp(point.y - enemy.y, -24, 24)

        if (distance < 16) {
            if (enemy.target == undefined) {
                enemysToBeMoved.delete(enemyCached);
            }
        }
        else if (distance > 250) {
            if (enemy.target != undefined) {
                delete state.enemys[enemyCached].target;

                console.log('Losing target, reason: too far.')
                callback({ [enemyCached]: { ...enemy } }, point);
            }
        }

        if (enemy.target != undefined) {
            if (distance >= 16) {
                callback({ [enemyCached]: { ...enemy } }, point);
            }
        }
        else {
            callback({ [enemyCached]: { ...enemy } }, point);
        }

    });
}

function isInsideFoundation(state, player) {
    var isInside = false;
    Object.entries(state.foundations).forEach(foundation => {
        //console.log(foundation[1].walls)
        var pX = player.x / 16;
        var pY = player.y / 16;
        if (pX >= foundation[1].x-1 && pX <= foundation[1].x + foundation[1].w+1 &&
            pY >= foundation[1].y-1 && pY <= foundation[1].y + foundation[1].h+1) {
            isInside = true;
            return isInside;
        }
    });
    return isInside;
}

function getDistance(p1, p2) {
    var a = p1.x - p2.x;
    var b = p1.y - p2.y;

    return Math.sqrt(a * a + b * b);
}

function clamp(num, min, max) {
    return num <= min ? min : num >= max ? max : num;
}