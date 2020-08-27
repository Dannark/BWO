const _statusMultiplier = 1;
const _startBaseHP = 10;

//regenLife 
export function regenerateHP(player) {
    var _maxHP = getMaxHP(player.lv);

    //var walkSpeed = Math.max(Math.abs(p.xSpeed), Math.abs(p.ySpeed));
    //walkSpeed == NaN || walkSpeed == undefined? 0 : null;

    if (player.hp < _maxHP) {
        player.hp += 1;
        console.log('>', player.name, 'regenerating HP:', player.hp);

        return true;
    }
    return false;
}

function getMaxHP(_level) {
    return parseInt(_statusMultiplier * (_startBaseHP + ((_level * _level) * .5)));
}

//
export function addExp(player, enemy) {
    var xp = enemy.lv * 2;
    player.xp += enemy.lv * 2;

    console.log('>', player.name, 'adding xp:', xp);
    levelUpRamp(player);
}

function levelUpRamp(player) {
    var startBaseExp = 10;
    var rampMultiplier = .35;
    var _maxExp = parseInt(player.lv * startBaseExp + ((player.lv * player.lv * player.lv) * rampMultiplier));

    if (player.xp > _maxExp) {
        player.lv++;
        player.xp -= _maxExp;
        player.hp = getMaxHP(player.lv);
        console.log(player.name, 'leveled up to:', player.lv);
    }

}