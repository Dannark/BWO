//import Required libraries
import fs from 'fs'
import startServer from './core/core_server.js'

//1. Load the initializers
var init_files = fs.readdirSync('./initializers/')
init_files.forEach(initFile => {
    console.log('Loading Initializer: '+initFile);
    //require('./initializers/'+initFile)
});

//2. load data models
var model_files = fs.readdirSync('./models/')
model_files.forEach(modelFiles => {
    console.log('Loading Models: '+modelFiles)
});
 
//3. load game maps data
const maps = {name:"main"}
var map_files = fs.readdirSync('./resources/data/maps/')
map_files.forEach(mapFiles => {
    console.log('Loading map: '+mapFiles)
});

//4. Initiate the server and listen to the internets
    //all of server logic
startServer();