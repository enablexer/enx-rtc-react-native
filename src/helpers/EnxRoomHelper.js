import { reassignEvents } from './EnxHelper';
import { each, isNull, isEmpty, isString,isBoolean } from 'underscore';

const sanitizeRoomEvents = (events) => {
  try {    
      if (typeof events !== 'object') {
    return {};
  }

  const customEvents = {
     ios: {
      roomConnected : 'didRoomConnected',
      roomError : 'didError',
      eventError :'didEventError',
      roomDisconnected: 'didDisconnected',
      streamPublished : 'didPublishedStream',
      streamAdded :'didStreamAdded',
      streamSubscribed : 'didSubscribedStream',
      activeTalkerList : 'didActiveTalkerList',
      recordStarted: 'didRoomRecordStart',
      recordStopped: 'didRoomRecordStop',
      startRecordingEvent: 'didStartRecordingEvent',
      stopRecordingEvent: 'didStopRecordingEvent',
      screenShareStarted: 'didScreenSharedStarted',
      sceenShareStopped: 'didScreenShareStopped',
      canvasStarted: 'didCanvasStarted',
      canvasStopped: 'didCanvasStopped',
      floorRequested: 'didFloorRequested',
      processFloorRequeted: 'didProcessFloorRequested',
      floorRequestReceived: 'didFloorRequestReceived',
      grantFloorRequested: 'didGrantFloorRequested',
      denyFloorRequested: 'didDenyFloorRequested',
      releaseFloorRequested: 'didReleaseFloorRequested',
      mutedAllUser: 'didMutedAllUser',
      unmutedAllUser: 'didUnMutedAllUser',
      hardMutedAll: 'didHardMutedAll',
      hardUnmuteAllUser: 'didHardUnMuteAllUser',
      userJoined: 'userDidJoined',
      userDisconnected: 'userDidDisconnected',
      logUpload: 'didLogUpload',
      publishStats: 'publishStats',
      subscribeStats: 'subscribeStats',
      setTalkerCount: 'didSetTalkerCount',
      getMaxTalkers: 'didGetMaxTalkers',
      getTalkerCount: 'didGetTalkerCount'
    },
    android: {
      roomConnected : 'onRoomConnected',
      roomError : 'onRoomError',
      eventError :'onEventError',
      roomDisconnected: 'onRoomDisConnected',
      streamPublished : 'onPublishedStream',
      streamAdded :'onStreamAdded',
      streamSubscribed : 'onSubscribedStream',
      activeTalkerList : 'onActiveTalkerList',
      recordStarted: 'onRoomRecordingOn',
      recordStopped: 'onRoomRecordingOff',
      screenShareStarted: 'onScreenSharedStarted',
      sceenShareStopped: 'onScreenSharedStopped',
      canvasStarted: 'onCanvasStarted',
      canvasStopped: 'onCanvasStopped',
      floorRequested: 'onFloorRequested',
      processFloorRequeted: 'onProcessFloorRequested',
      floorRequestReceived: 'onFloorRequestReceived',
      grantFloorRequested: 'onGrantedFloorRequest',
      denyFloorRequested: 'onDeniedFloorRequest',
      releaseFloorRequested: 'onReleasedFloorRequest',
      mutedAllUser: 'onMutedRoom', //Moderator
      unmutedAllUser: 'onUnMutedRoom',//Moderator
      hardMutedAll: 'onReceivedMuteRoom',//Participant
      hardUnmuteAllUser: 'onReceivedUnMutedRoom',//Participant
      userJoined: 'onUserConnected',
      userDisconnected: 'onUserDisConnected',
      logUpload: 'onLogUploaded',
      publishStats: 'publishStats',
      subscribeStats: 'subscribeStats',
      setTalkerCount: 'onSetTalkerCount',
      getMaxTalkers: 'onMaxTalkerCount',
      getTalkerCount: 'onGetTalkerCount'
    },
  };
   return reassignEvents('room', customEvents, events);
  } catch (error) {
    console.log("sanitizeRoomEventsError",error);
  }
};

const sanitizeLocalInfoData = (localInfo) => {
  if (typeof localInfo !== 'object') {
    return {
        audio: false,
        video: false,      	  
        data:false,     
        maxVideoBW:"",  
        minVideoBW:"",      
        audioMuted:false, 	
        videoMuted:false, 
        name: "" , 
        minWidth: "",
        minHeight: "", 
        maxWidth: "", 
        maxHeight: "" 
    };
  }
  return {
    audio: validateBoolean(localInfo.audio),
    video: validateBoolean(localInfo.video),
    data: validateBoolean(localInfo.data),
    maxVideoBW: validateString(localInfo.maxVideoBW),
    minVideoBW: validateString(localInfo.minVideoBW),
    audioMuted: validateBoolean(localInfo.audioMuted),
    videoMuted: validateBoolean(localInfo.videoMuted),
    name: validateString(localInfo.name),
    minWidth: validateString(localInfo.minWidth),
    minHeight: validateString(localInfo.minHeight),
    maxWidth: validateString(localInfo.maxWidth),
    maxHeight: validateString(localInfo.maxHeight),
  };
};

const validateString = value => (isString(value) ? value : '');

const validateBoolean = value => (isBoolean(value) ? value : false);

const sanitizeBooleanProperty = property => (property || property === undefined ? true : property);

export {
  sanitizeRoomEvents,
  sanitizeLocalInfoData,
  sanitizeBooleanProperty,
};
