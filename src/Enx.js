import { NativeModules, NativeEventEmitter } from 'react-native';
import { each } from 'underscore';

const Enx = NativeModules.EnxRoomManager;
const nativeEvents = new NativeEventEmitter(Enx);

const setNativeEvents = (events) => {
  const eventNames = Object.keys(events);
  Enx.setNativeEvents(eventNames);
  Enx.enableLogs(true)
  console.log("EnxEventName",eventNames);
  
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
};
