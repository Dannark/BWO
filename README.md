# Borderless World Online (BWO)

[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)[![Powered by Flame](https://img.shields.io/badge/Powered%20by-%F0%9F%94%A5-orange.svg)](https://flame-engine.org)

An infinity procedural online game using Flutter and flames with NodeJS and Firebase for the back-end.

![gameplay1](https://user-images.githubusercontent.com/7622553/90344825-b0887000-dff3-11ea-9d1e-eca2ec55af6f.gif)
![export](https://user-images.githubusercontent.com/7622553/88120935-99906280-cb9a-11ea-9f4a-05c6b5d9ab61.gif)
![bulding tools](https://user-images.githubusercontent.com/7622553/90987921-239a6500-e565-11ea-92c9-133f4e4f58fd.gif)

### On the Table
The world isn't stored in anywhere, it uses some conecpts and rules (`Perlin Noise` and `Simplex Noise`) to generate it equaly in all devices only the changes made by player are actually stored on the server side.

The players will be able to build theirs houses anywhere on the infinity world. That's why i call it borderless world in first place. :)

This project is still in development and it doesnt have many features yet

### Release Date?
Hopefully at some point later this year.

## Instructions:
1. Requirements
    - The [NPM and NodeJS](https://www.npmjs.com/get-npm) installed on your system
    - Navigate to the folder `bwo-server` and run on the console the command `npm install` to install and update all the dependences

2. Run the Node Server:
    - Navigate to the folder `bwo-server` and run on the console the command `npm start` or `node server.js` or just `nodemon`
        - To Run test on the Server side run `npm test` (still in development)
        - To specify an environment use `--env=development` or `--env=production`
        - If you want to use firebase in production mode, create a project in firebase console and edit the enviroment variables in `resources/config.js`

3. Adjust the Server URL on the `lib\server\utils\server_utils.dart` if you want to use your own server (localhost for example)
    - Tip: You can use gitpod to launch it alive for free

4. Launch the app on your device
    - Left tap on screen = walk
    - Right tap on screen = cut tree/attack
    - While in build mode you can't walk and can only place object inside the foundation square 

You can also open the host url on your browser to see the currently server state (for debuging)

## Dev Log
Usecases:
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
    - [x] Add More Life to the environment
    - [ ] Move camera around player when he is afk
* [x] Add Cut Tree Animation do player
* [x] Add fruits fell when hiting trees
* [x] Tree Cut Logic and Animation
* [x] Add pickup items
* [x] Inventory 
* [x] Enemys Category
    - [x] AI patrol (local)
    - [x] AI Search, follow and lose target (local)
    - [x] AI Attacking (local)
    - [x] Generate Random Enemys when walking (online)
* [x] Add player Attack animation
* [x] Add combat System
* [x] Add UI System
* [x] Added Scene Manager (Switch between Scenes like Menus, Game etc)
* [x] Add UI - player creation
* [x] Added New Character Sprites to the game
* [x] Level and Progression System
* [x] Player HUD
* [x] Equipments and status bonuses
* [x] Add hungriness
* [x] Add Input Joystick Style for walking
* [-] Create Node Server
    - [x] Synchronize Players position
    - [x] Smooth player animation
    - [x] Optimze Synchronization player's data only to players in view range
    - [x] Sync hit tree animation / state / respawn
    - [x] Sync enemies
    - [ ] Sync attack other Players damage/animation
    - [ ] Sync Equipment Sprite 
    - [ ] Sync items spawn
* [-] Craft Category
    - [ ] Craft Axe item from others items
    - [ ] Craft Database
    - [ ] Craft UI with drag and drop
* [-] Build Category
    - [X] Foundation for private building
    - [x] Wall placements
    - [x] Auto/Toggle wall tall level
    - [x] Delete Foundations
    - [ ] Ground Tiles
    - [ ] Animated Doors
    - [ ] Static objects like Windows, furnitures and so on
    - [ ] Object Windows selection
    - [ ] Craft or buying system
    - [ ] Sync building to the server
* [-] Interfaces
    * [ ] Create Account UI
    * [x] Character Creation UI
    * [ ] Login UI
    * [ ] Equipments UI
* [ ] Change background music Volume dynamic
* [ ] Add NoSQL database
* [ ] Biomes

### Know Problems / Missing
- Sometimes slipping a too much when receiving walks updates
- [Missing] life time to enemies so they will die normally (to not overpopulate the server)
- [Missing] Code refactoring Server-side and Client-side
- [Missing] Game Diagram and comments

### Focusing on / Doing Now
- Ground tilesets
- Animated doors

## 25/08
* Added firebase database to save persistence data

## 24/08
* Added 02 new sprite characters
* Added Toggle wall tall level (Auto, low and tall)

## 23/08
* Added Foundation for private House Build System
* Added Wall Placement on terrain

### 21/08
* Added Leveled Up System from Server
* Synchronized: hit tree action
* Synchronized: Tree health / Tree Dying animation / respawn after 180s

### 19/08
* Fixing bad UI elements position on some devices.
* Added logs record on server
* Added Player HP Regeneration from server
* Added XP reward for killing monster from server
* Fixed order male1 left/right walk sprite animation
* Changed Keyboard open animation and auto capitalize

### 17/07
* Added heroku server for tests.

### 16/08
* Fixed enemy walk when it goes offscreen
* Improviment on enemy's reaction when a player is on its range and attack delay
* Synchronized Players Attack to Enemys

### 13/08
* Added Effective Dart to the project (Massive refactoring)

### 11/08
* Added Jasmine for (TDD) on the back-end Server
* Make the Enemy loses its target when he dies

### 07/08
* New enviroment Production/Development updates when starting server
* Fixed Spawn Players position after previous update
* Fixed not loading grass textures
* Adedd Wakelock (Screen will keep Aweake)
* Fixed Rare bug when enemys spawn with NaN Values

### 03/08
* Rebuilng Logic to Synchronize enemy walk with speed simulation from Server-Side (This is need to calculate when enemy is REALLY close to player, instead of "teleporting" to from backend while in front they are not close)

### 01/08
* Added Server-Side Folder to the project

### 30/07
* Reducing Log amount for Socket.io Lib
* Enemys Name
* Some Improviments on Connections to Server when receving messages update

### 26/07
* Realtime Enemy Spawn/Walk Synchronization (Client side)

### 24/07
* Added Input Joystick Style for walking (Accelerometer is still very interesting and different but it is just too hard for some people)
* Fixed Enemys not spawning when off screen
* Damage Text Colors for Enemys/Player
* Enemys not patroling

### 21/07
* Added Level and progression System
* Added Equipments items and bonus status (Single Source shared to all characters)
* Added Players HUD and status management logic
* Added Axe to cut tree faster
* Added calories logic (If you are starving you get badness status and limitations)

### 17/07
* New Players sprites
* Fixed Tree Generation (Sometimes it was random)
* Minior map improviments
* Fixed some Server Side Logic
* Added offline mode for debug

### 15/07
* Added 3 New Playable Sprites to play with
* Added Start Location Selection
* Character Creation UI
* Added new UI Buttons and Keyboards

### 10/07
* Solved problem not updating players when entering on my screen
* Removed Google Firebase, using Node.js Server instead
* Sync players position to camera view only

### 07/07
* Added Realtime connection to Google Firebase.

### 04/07
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