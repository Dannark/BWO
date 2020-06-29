# Borderless World Online (BWO)

An infinity procedural online game using Flutter with Firebase and flames.

![gameplay_2](https://user-images.githubusercontent.com/7622553/85237229-923f3300-b3fb-11ea-972e-bc55fad85d83.gif)

### On the Table
The world isn't stored in anywhere, it uses some conecpts and rules to generate it equaly in all devices only the changes made by player are actually stored on the firebase.

The players will be able to build theirs houses anywhere on the infinity world. That's why i call it borderless world in first place. :)

This project is still in development and right now it only has some fews features:

- A map generator for a real infinity Map with a mix of `Perlin Noise` and `Simplex Noise` without losing the performance.
- Trees generation
- Map Viewport and Map Follow Object Moviment
- Temporaraly Saving generated data for best perfomance

## Dev Log

- 21/06
* Right now i'm focusing on the performance improviments in order to bring it the best fps as i can.
* Next steps will be the player design it self and collision detection with the enviroment.

- 23/06
* Added player sink into the water and Trees collision detection.

- 24/06
* Added walk/Swim and water effects + animations

- 26/06
* Added Random Grass/flowers sprites, 
* Changing colors Pallet to get more 'look and feel' of the game.
* Added Collision in the mountain
* Ambient Music and footstep walk

- 28/06
* Player movment changed - now you need to be taping on screen to move him.
* Player Sprite changed
* Hit tree player animation

Next updates:
* [ ] Optimze render and map Generator
* [x] Fix player animation Position
* [x] Add shadow to the environment
* [x] Stop player walk when device is totally lying down
* [-] Especial Effects 
    - [x] walk smoke 
    - [x] water ripple
    - [x] water foam
    - [x] water stars blink
    - [x] sound effects bgm, walk and swim
    - [ ] Add environment objects
    - [ ] Move camera around player when he is afk
* [x] Add Cut Tree Animation do player
* [ ] Tree Cut Logic and Animation
* [ ] Add fruits fell when hiting trees
* [ ] Add pickup items and inventory
* [ ] Add enemys
* [ ] Add player Attack animation
* [ ] Add combat System
* [ ] Add UI and HUD
* [ ] Add Firebase connectivity to sync the game