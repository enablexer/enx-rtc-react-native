import { Platform } from 'react-native';
import { each } from 'underscore';

const reassignEvents = (type, customEvents, events) => {
  const newEvents = {};
  const preface = `${type}:`;
  const platform = Platform.OS;
  console.log(preface,customEvents,events,newEvents);
  each(events, (eventHandler, eventType) => {
     if(customEvents[platform][eventType] !== undefined ) {  
      newEvents[`${preface}${customEvents[platform][eventType]}`] = eventHandler;
    } else {
    console.log("custom  Event error");
    }
  });
  return newEvents;
};

export {
  reassignEvents,
};
