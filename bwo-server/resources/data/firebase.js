import firebase from '@firebase/app';
import "@firebase/database";
//import * as admin from "firebase-admin";

var eventReceived = 0;
export function isReady(){
  return eventReceived >= 2;
}

let db;

export function startFirebase(mConfig){
  var defaultApp = firebase.default.initializeApp(mConfig);
  db = firebase.default.database();

  var ref = db.ref("version");
  ref.once("value", function (snapshot) {
    db_version = snapshot.val();
    console.log('> Connected to Firebase:', defaultApp.name, 'version:', db_version);
    eventReceived ++;
  });

  let ref_state = db.ref("state");
  ref_state.once("value", function (snapshot) {
    my_state = snapshot.val();

    eventReceived++;
  });
}

export function writeState(state) {
  db.ref('state/').set(state);
}

export function writeLog(log,log_id) {
  db.ref('log/'+log_id).set(log);
}

export let db_version;
export var my_state;