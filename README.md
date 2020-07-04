# Borderless World Online (BWO)

An infinity procedural online game using Flutter with Firebase and flames.

![gameplay_2](https://user-images.githubusercontent.com/7622553/86072224-7d941800-ba57-11ea-8d1d-9a2cab5c08b4.gif)

### On the Table
The world isn't stored in anywhere, it uses some conecpts and rules to generate it equaly in all devices only the changes made by player are actually stored on the firebase.

The players will be able to build theirs houses anywhere on the infinity world. That's why i call it borderless world in first place. :)

This project is still in development and right now it only has some fews features:

- A map generator for a real infinity Map with a mix of `Perlin Noise` and `Simplex Noise` without losing the performance.
- Trees generation
- Map Viewport and Map Follow Object Moviment
- Temporaraly Saving generated data for best perfomance

## Dev Log

Next updates:
* [x] Optimze render and map Generator
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
* [x] Add fruits fell when hiting trees
* [x] Tree Cut Logic and Animation
* [x] Add pickup items
* [x] Inventory 
* [x] Add enemys
    - [x] AI patrol
    - [x] AI Search, follow and lose target
    - [x] AI Attacking
* [x] Add player Attack animation
* [x] Add combat System
* [x] Add UI
* [ ] Level and Progression System
* [ ] Player HUD
* [ ] Add Firebase connectivity to sync the game
* [ ] Fix tree generation
* [ ] Add hungriness
* [ ] Change background music Volume dynamic


## 04/07
* Added Combat System (Damage/Death/Respawn)
* Added AI Attack
* Added Damage Text Display on UI

### 03/07
* Added AI System
* Added new Enemy [Skull]

### 02/07
* Tree Cut Logic/Animation and Respawn
* Added Log Item
* Added Pickup Items
* Added Inventory System
* Added Click Detection
* Added HUD and UI System

### 29/06
* Gravity, friction and bouncy Physics
* Added Drop item logic

### 28/06
* Player movment changed - now you need to be taping on screen to move him.
* Player Sprite changed
* Hit tree player animation

### 26/06
* Added Random Grass/flowers sprites, 
* Changing colors Pallet to get more 'look and feel' of the game.
* Added Collision in the mountain
* Ambient Music and footstep walk

### 24/06
* Added walk/Swim and water effects + animations

### 23/06
* Added player sink into the water and Trees collision detection.

### 21/06
* Right now i'm focusing on the performance improviments in order to bring it the best fps as i can.
* Next steps will be the player design it self and collision detection with the enviroment.