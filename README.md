# Borderless World Online (BWO)

[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)[![Powered by Flame](https://img.shields.io/badge/Powered%20by-%F0%9F%94%A5-orange.svg)](https://flame-engine.org)

An infinity procedural online game using Flutter and flames with NodeJS and Firebase for the back-end.

![showcase5](https://user-images.githubusercontent.com/7622553/93117099-add17700-f694-11ea-931b-979ea1eb7123.gif)
![showcase1](https://user-images.githubusercontent.com/7622553/91732240-59030c00-eb7e-11ea-96e5-2e854e10e597.gif)

### On the Table
The world isn't stored in anywhere, it uses some conecpts and rules (`Perlin Noise` and `Simplex Noise`) to generate it equaly in all devices only the changes made by player are actually stored on the server side.

The players will be able to build theirs houses anywhere on the infinity world. That's why i call it borderless world in first place. :)

This project is still in development and it doesnt have many features yet.
I'm using the `solid principles` as much as i can, make things clear enough easy to read although i'm not an expert on it, if you have any suggestion, please let me know it.

### Release Date?
Hopefully at some point later this year.
> Current Version: [1.0.4](https://drive.google.com/drive/folders/1lX372_MqHEnUDRCQkkTJY7llI3NmbIsh?usp=sharing)

## Game Diagram, Structure and Comments
[![BWO](https://user-images.githubusercontent.com/7622553/92182369-f3cf4500-ee21-11ea-96e5-08a1735f96d8.png)](https://whimsical.com/CkYzWZKNNz5is2GY4Y2yDY@2Ux7TurymMxHuu3kArnA)
For more detail access [Whimsical Diagram Page](https://whimsical.com/CkYzWZKNNz5is2GY4Y2yDY@2Ux7TurymMxHuu3kArnA) to see the comments in each node.

## Instructions:
1. Requirements
    - The [NPM and NodeJS](https://www.npmjs.com/get-npm) installed on your system
    - Navigate to the folder `bwo-server` and run on the console the command `npm install` to install and update all the dependences

2. Launch your own server :
    - 2.1 Setup the database if you want to run it Online:
        - Create a project and setup your Firebase database and Cloud Firestore on [Google console](console.firebase.google.com)
            - Save the `google-services.json` file in `android\app\`
        - Edit the enviroment variables in `resources/config.js` or set them in your system so the server can connects to your database.

    - 2.2. Run the Node Server:
        - Navigate to the folder `bwo-server` and run on the console the command `npm start` or `node server.js`
            - To specify an environment use `--env=development` or `--env=production` in both case you need to be authenticated in firebase. For localhost use `--env=localhost`
            - To Run test on the Server side run `npm test` (still in development)

    - 2.3 For the client-side (Android App), Adjust the Server URL in `lib\server\utils\server_utils.dart`
        - Set your database name `development`, `production`, `localhost`
        - Tip: You can host in gitpod or heroku to launch it alive for free

3. If you do not want to configure your own server and just want to run the game: (Localhost)
    - Make sure to adjust the `server` variable URL in `lib\server\utils\server_utils.dart` to `https://borderless-world.herokuapp.com`
    - Make sure to adjust the `isOffline` variable in `lib\server\utils\server_utils.dart` to `true`

4. Launch the app on your device
    - Left tap on screen = walk
    - Right tap on screen = cut tree/attack
    - While in build mode you can't walk and can only place/delete object inside the foundation square 

You can also open the host url on your browser to see the currently server state (for debuging)

And please, let me know if you have any problems, `open an issue` and i will be in touch very soon. Code refactoring are really appreciated at this point.

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
    - [x] UI object selection interface
    - [x] Ground Tiles
    - [x] Roofs
    - [x] Animated Doors
    - [x] Windows
    - [x] Craft or buying system
    - [x] Sync building to the server
        - [x] Walls
        - [x] floors
        - [x] furnitures
    - [x] Save/backup Foundation/House from server to firebase
* [-] Interfaces
    * [x] Create Account UI
    * [x] Character Creation UI
    * [x] Login UI
    * [ ] Equipments UI
* [ ] Change background music Volume dynamic
* [x] Firebase to backup server state
* [x] Handle users login on database
* [ ] Biomes
* [ ] Dynamic bundle and CI/CD for playstore
* [ ] Global Chat System
* [x] UML Game Diagram
* [x] Safe zone to foundations
* [ ] Random Maze dungeon and loots

### Know Problems
- Sometimes slipping a too much when receiving walks updates
- Enemys won't collide with walls. Missing Path Finding

### Doing now
* Performance improviments

### Next
* Code refactoring
* New Enemy
* Enemy Passive Aggressive

# 22/09
* New Enemy
> ![forward_right](https://user-images.githubusercontent.com/7622553/93885188-429e2b00-fcba-11ea-9e95-085a4c2a9850.gif)

## 18/09
* Fixed bug when dragging foundation area preview outsite of the screen area
* Fixed but when creating character after flames update
* Reducing foundation load area from server, it will load only if you are close enough to the edge screen
* Added option to build foundation over cutted tree spot

## 17/09
* Server Send Messages big improviments
* Foundations are now safe zone, this means enemys wont attack you there

## 13/09
* Added Doors
* Auto open/close doors when player is close
* Added remove furniture functionality to Delete Tool
* Furniture Colisions checks and validation for placements
> ![doors](https://user-images.githubusercontent.com/7622553/93029898-24b73300-f5f5-11ea-9704-31fab953bcec.gif)

### 09/09
* Added Roofs
> ![roofs](https://user-images.githubusercontent.com/7622553/92657686-a17f9f80-f2cb-11ea-92b6-34e4395488e2.png)

### 08/09
* Furniture Synchronization
* Added upstairs Wall level layer to respective button (Used to show Roofs in near future)

### 07/09
* Added Wall Mutitexture

> ![wall_multexture1](https://user-images.githubusercontent.com/7622553/92427748-a6c1da80-f163-11ea-85ca-957ae05ec5f2.gif)

### 06/09
* Fixed floors not beeing placed when terrain had not finished to build
* Added Furniture Select and Placement
* Added floor and furnitures sprites

### 04/09
* Added Toast notification message
* Added Tree HP regeneration and delete from server after hp is full
* Fixed Foundations not loading issue
* Backup Foundation to firebase

### 03/09
* Fixed some performances issues when updating walls

### 01/09
* Added Floor to build system

### 30/08
* Added Wall windows selector
* Added Foundation Windows selector, placement area indicator drag, Color indicator when it is safe or not to move
* Server validations for Foundations
* UI Build System

## 28/08
* Added Wall Placement synchronization over the server. *Finally!:O* (Not saving data yet)
* Added server send menssages improviments when walking
* Added new sprites
* Started Build windows action (not finished)

## 26/08
* Added Google sign in method Authentication
* Saving User character data and user account to firebase
* Added Merge function between firebase and server data
* Enemies are no longer saved permanently as since they are spawned as you walk, also a good idea for cleanin up the server on each restart

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