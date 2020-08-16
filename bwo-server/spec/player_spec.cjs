var conn = require('./connect.cjs')

let player = {
  name: "Unit Test Player",
  sprite: "human/male1",
  x: Math.random() * 100,
  y: Math.random() * 100
};

describe("Checks for new connections:", () => {
  
  it('should connect to server', function(done) {
    conn.open(function(isConnected) {
      expect(isConnected).toEqual(true);
      done();
    });
  });


  it('should create the player on the server', function(done) {
    conn.login(player, function(result) {
      expect(result).toEqual(true);
      done();
    });
  });

})

describe("Player interaction with the world:", () => {

  for (let index = 0; index < 10; index++) {
    it('should move and receive others players update. Try no #0'+(index+1), function(done) {
      player = {
        ...player,
        x: player.x + Math.random() * 16,
        y: player.y + Math.random() * 16,
        "xSpeed": 0,
        "ySpeed": 1
      };
  
      conn.move(player, function(result) {
        var isEmpty = Object.keys(result).length === 0 && result.constructor === Object

        if(isEmpty){
          expect(result).toEqual({}); //ok
        }
        else if(result == undefined | null){
          //not oks
          expect(result).not.toBe(undefined);
          expect(result).not.toBe(null);
        }
        else{
          const p = Object.entries(result)[0];
          expect(p[0]).not.toBe(null | undefined);
          
          expect(p[1].name).not.toBe(undefined | null);
          expect(p[1].playerId).not.toBe(undefined | null);
          expect(p[1].sprite).not.toBe(undefined | null);
          expect(Number.isInteger(p[1].x)).toBe(true);
          expect(Number.isInteger(p[1].y)).toBe(true);
        }
        
        done();
      });
    });
  }

  
})

describe("Desconnect player", () =>{
  it('should disconnect the player from the server', function() {
    conn.disconnect();
    
  });
})


afterAll(done => {
  console.log('\x1b[36m%s\x1b[0m', '\n> All tests passed [OK]!');  //cyan
  done();
});