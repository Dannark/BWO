# Borderless World Online (BWO)

[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)[![Powered by Flame](https://img.shields.io/badge/Powered%20by-%F0%9F%94%A5-orange.svg)](https://flame-engine.org)

An infinity procedural online game using Flutter and flames with NodeJS Server In back-end.

![gameplay1](https://user-images.githubusercontent.com/7622553/90344825-b0887000-dff3-11ea-9d1e-eca2ec55af6f.gif)
![export](https://user-images.githubusercontent.com/7622553/88120935-99906280-cb9a-11ea-9f4a-05c6b5d9ab61.gif)

### On the Table
The world isn't stored in anywhere, it uses some conecpts and rules (`Perlin Noise` and `Simplex Noise`) to generate it equaly in all devices only the changes made by player are actually stored on the server side.

The players will be able to build theirs houses anywhere on the infinity world. That's why i call it borderless world in first place. :)

This project is still in development and right now it only has some fews features:

### Release Date?
Hopefully at some point later this year.

## Instructions:
1. Run the Node Server:
    - Navigate to the folder `bwo-server` and run on console the command `npm start` or `node server.js` or just `nodemon`
        - To Run test on Server `npm test` (still in development)
        - To reset the state and delete all enemy (saved on a .txt file for test propose) use `--resetstate`
        - To specify an environment use  `--env=development` or `--env=production`
2. Adjust the Server URL on the `lib\server\utils\server_utils.dart` if you want to use your own server (localhost for example)
    - Tip: You can use gitpod to launch it alive for free
3. Launch the app on your device

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
* [ ] Equipments UI
* [x] Fix tree generation
* [x] Add hungriness
* [x] Add Input Joystick Style for walking
* [ ] Change background music Volume dynamic
* [-] Create Node Server
    - [x] Synchronize Players position
    - [x] Smooth player animation
    - [x] Optimze Synchronization player's data only to players in view range
    - [x] Sync hit tree animation
    - [ ] Sync attack other Players damage/animation
    - [ ] Sync Equipment Sprite 
    - [x] Sync tree/items spawn
    - [x] Sync enemies
* [-] Craft Category
    - [ ] Craft Axe item from others items
    - [ ] Craft Database
    - [ ] Craft UI with drag and drop
* [-] Build Category
    - [ ] Think about the Logic and rules to limite players for placing items on world
    - [ ] Place Objects like walls, doors, foundation and so on

## Focusing on / Doing Now / Missing / Problems:
- Enemy Attack Sync
- Add NoSQL database
- Login/Creation user
- Sync Player Attack Animation
- [Problem]Walk slip offset when walking
- Sync Player status (like health regen)

### 17/07
* Added heroku server so we can test it online. ❤️

### 16/08
* Fixed enemy walk when it goes offscreen
* Improviment on enemy's reaction when a player is on its range and attack delay
* Synchronized Players Attack to Enemys

### 13/08
* Added Effective Dart to the project (Massive refactoring)

### 11/08
* Added Jasmine for Testing Driven-Development (TDD) on the back-end Server
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