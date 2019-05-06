import { reassignEvents } from "./EnxHelper";

const sanitizePlayerViewEvents = events => {
  if (typeof events !== 'object') {
    return {};
  }
  const customEvents = {
    ios: {
      audioEvent: 'didAudioEvent',
      videoEvent: 'didVideoEvent',
      hardMuteAudio: 'didHardMuteAudio',
      hardUnmuteAudio: 'didhardUnmuteAudio',
      recievedHardMutedAudio: 'didRecievedHardMutedAudio',
      recievedHardUnmutedAudio: 'didRecievedHardUnmutedAudio',
      hardVideoMute: 'didHardVideoMute',
      hardVideoUnmute: 'didHardVideoUnMute',
      receivehardMuteVideo: 'didReceivehardMuteVideo',
      recivehardUnmuteVideo: 'didRecivehardUnmuteVideo',
      receiveData: 'didReceiveData',
      remoteStreamAudioMute :'didRemoteStreamAudioMute',
      remoteStreamAudioUnMute:'didRemoteStreamAudioUnMute',
      remoteStreamVideoMute:'didRemoteStreamVideoMute',
      remoteStreamVideoUnMute:'didRemoteStreamVideoUnMute'
    },
    android: {
      audioEvent: 'onAudioEvent',
      videoEvent: 'onVideoEvent',
      hardMuteAudio: 'onHardMutedAudio',
      hardUnmuteAudio: 'onHardUnMutedAudio',
      recievedHardMutedAudio: 'onReceivedHardMuteAudio',
      recievedHardUnmutedAudio: 'onReceivedHardUnMuteAudio',
      hardVideoMute: 'onHardMutedVideo',
      hardVideoUnmute: 'onHardUnMutedVideo',
      receivehardMuteVideo: 'onReceivedHardMuteVideo',
      recivehardUnmuteVideo: 'onReceivedHardUnMuteVideo',
      receiveData: 'onReceivedData',
      remoteStreamAudioMute :'onRemoteStreamAudioMute',
      remoteStreamAudioUnMute:'onRemoteStreamAudioUnMute',
      remoteStreamVideoMute:'onRemoteStreamVideoMute',
      remoteStreamVideoUnMute:'onRemoteStreamVideoUnMute'
    }
  };
  return reassignEvents('stream', customEvents, events);
};

export { sanitizePlayerViewEvents };
