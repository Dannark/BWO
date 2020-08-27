import firebase from '@firebase/app';
import "@firebase/database";
//import * as admin from "firebase-admin";

var eventReceived = 0;
export function isReady(){
  return eventReceived >= 2;
}

let db;
let db_name;

export function startFirebase(mConfig){
  var defaultApp = firebase.default.initializeApp(mConfig.database_conf);
  db = firebase.default.database();

  db_name = mConfig.database+"/";

  var ref = db.ref("version");
  ref.once("value", function (snapshot) {
    db_version = snapshot.val();
    console.log('> Connected to Firebase:', mConfig.database, 'version:', db_version);
    eventReceived ++;
  });

  let ref_state = db.ref(db_name+"state");
  ref_state.once("value", function (snapshot) {
    my_state = snapshot.val();

    eventReceived++;
  });
}

export function writeState(state) {
  db.ref(db_name+'state/').update(state);
}

export function writeLog(log,log_id) {
  db.ref(db_name+'log/'+log_id).set(log);
}

export let db_version;
export var my_state;