import { NativeModules, NativeEventEmitter, PermissionsAndroid } from 'react-native';
import { each } from 'underscore';

const Enx = NativeModules.EnxRoomManager;
const nativeEvents = new NativeEventEmitter(Enx);

const checkAndroidPermissions = () => new Promise((resolve, reject) => {
  PermissionsAndroid.requestMultiple([
    PermissionsAndroid.PERMISSIONS.CAMERA,
    PermissionsAndroid.PERMISSIONS.RECORD_AUDIO
])
    .then((result) => {
      const permissionsError = {};
      permissionsError.permissionsDenied = [];
      each(result, (permissionValue, permissionType) => {
        if (permissionValue === 'denied') {
          console.log("denied Permission");
          permissionsError.permissionsDenied.push(permissionType);
          permissionsError.type = 'Permissions error';
        }
      });
      if (permissionsError.permissionsDenied.length > 0) {
          console.log("denied Permission");
        reject(permissionsError);
      } else {
          console.log("granted Permission");
        resolve();
      }
    })
    .catch((error) => {
      reject(error);
    });
});

const setNativeEvents = (events) => {
  const eventNames = Object.keys(events);
  Enx.setNativeEvents(eventNames); 
  each(events, (eventHandler, eventType) => {
    const allEvents = nativeEvents.listeners();
    if (!allEvents.includes(eventType)) {
      nativeEvents.addListener(eventType, eventHandler);
    }
  });
};

const removeNativeEvents = (events) => {
  const eventNames = Object.keys(events);
  Enx.removeNativeEvents(eventNames);
  each(events, (eventHandler, eventType) => {
    nativeEvents.removeListener(eventType, eventHandler);
  });
};

export {
  Enx,
  nativeEvents,
  setNativeEvents,
  removeNativeEvents,
  checkAndroidPermissions,
};
