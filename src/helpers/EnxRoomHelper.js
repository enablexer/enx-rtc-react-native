import { reassignEvents } from './EnxHelper';
import { isString,isBoolean } from 'underscore';

const sanitizeRoomEvents = (events) => {
  try {    
      if (typeof events !== 'object') {
    return {};
  }

  const customEvents = {
     ios: {
      roomConnected : 'didRoomConnected', /* Event called on success of room connection. */
      roomError : 'didError', /* Event called on error while room connection. */
      eventError :'didEventError', /* Event called on any event error. */
      roomDisconnected: 'didDisconnected', /* Event called on any event error. */
      streamPublished : 'didPublishedStream', /* Event called on publish stream success. */
      streamAdded :'didStreamAdded', /* Event called on stream added in the room. */
      streamSubscribed : 'didSubscribedStream', /* Event called on subscribe stream success. */
      activeTalkerList : 'didActiveTalkerList', /* Event called to get updated active talker list. */
      recordStarted: 'didRoomRecordStart', /* Event when recording is started in the room, (either implicitly or explicitly), all connected users are notified that room is being recorded.. */
      recordStopped: 'didRoomRecordStop', /* Event when the recording is turned off (either implicitly or explicitly), all connected users are notified that recording has been stopped in the room. */
      startRecordingEvent: 'didStartRecordingEvent', /* Event called when recording started by the moderator. */
      stopRecordingEvent: 'didStopRecordingEvent', /* Event called when recording stopped by the moderator. */
      screenShareStarted: 'didScreenSharedStarted', /* Event called when screen share started. */
      sceenShareStopped: 'didScreenShareStopped', /* Event called when screen share stopped. */
      canvasStarted: 'didCanvasStarted', /* Event called when screen canvas stopped. */
      canvasStopped: 'didCanvasStopped', /* Event called when screen canvas stopped. */
      floorRequested: 'didFloorRequested', /* Event for participant on the success of requestFloor. This is for participant only. */
      processFloorRequeted: 'didProcessFloorRequested', /* Event for Moderator on performing actions like grantFloor, denyFloor, releaseFloor. */
      floorRequestReceived: 'didFloorRequestReceived', /* Event for Moderatoron any Floor Request raised by the participant. This is for Moderator only. */
      grantFloorRequested: 'didGrantFloorRequested', /* Event for Participant when the moderator performs action grantFloor. */
      denyFloorRequested: 'didDenyFloorRequested', /* Event for Participant when the moderator performs action denyFloor. */
      releaseFloorRequested: 'didReleaseFloorRequested', /* Event for Participant when the moderator performs action releaseFloor. */
      mutedAllUser: 'didMutedAllUser', /* Event for called when the room is muted by the moderator. Available to Moderator only. */
      unmutedAllUser: 'didUnMutedAllUser', /* Event for called when the room is unmuted by the moderator. Available to Moderator only. */
      hardMutedAll: 'didHardMutedAll', /* Event for Participants when room is muted by any moderator. */
      hardUnmuteAllUser: 'didHardUnMuteAllUser', /* Event for Participants when room is unmuted by any moderator. */
      userJoined: 'userDidJoined', /* Event when a user is connected to a room, all other connected users are notified about the new user. */
      userDisconnected: 'userDidDisconnected', /* Event called when a user is disconnected from a room, all other connected users are notified about the users exit. */
      logUpload: 'didLogUpload', /* Event called when the log is uploaded successfully to the server. */
      setTalkerCount: 'didSetTalkerCount', /* Event called when the user set number of active talker. */
      getMaxTalkers: 'didGetMaxTalkers', /* Event to get the maximum number of allowed Active Talkers in the connected room. */
      getTalkerCount: 'didGetTalkerCount' /* Event called when the user request to get opted active talker streams set by them. */
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
