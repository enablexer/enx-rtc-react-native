package com.rnenxrtc;

import android.support.annotation.Nullable;
import android.util.Log;

import com.facebook.react.bridge.Arguments;


import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.concurrent.ConcurrentHashMap;

import enx_rtc_android.Controller.EnxChairControlObserver;
import enx_rtc_android.Controller.EnxLogsObserver;
import enx_rtc_android.Controller.EnxLogsUtil;
import enx_rtc_android.Controller.EnxMuteAudioStreamObserver;
import enx_rtc_android.Controller.EnxMuteRoomObserver;
import enx_rtc_android.Controller.EnxMuteVideoStreamObserver;
import enx_rtc_android.Controller.EnxPlayerView;
import enx_rtc_android.Controller.EnxRecordingObserver;
import enx_rtc_android.Controller.EnxRoom;
import enx_rtc_android.Controller.EnxRoomObserver;
import enx_rtc_android.Controller.EnxRtc;
import enx_rtc_android.Controller.EnxScreenShareObserver;
import enx_rtc_android.Controller.EnxStream;
import enx_rtc_android.Controller.EnxStreamObserver;
import enx_rtc_android.Controller.EnxTalkerObserver;

public class EnxRoomManager extends ReactContextBaseJavaModule implements EnxRoomObserver, EnxStreamObserver, EnxRecordingObserver, EnxScreenShareObserver, EnxTalkerObserver, EnxLogsObserver, EnxChairControlObserver, EnxMuteRoomObserver, EnxMuteAudioStreamObserver, EnxMuteVideoStreamObserver {
    private ReactApplicationContext mReactContext = null;
    private ArrayList<String> jsEvents = new ArrayList<String>();
    private ArrayList<String> componentEvents = new ArrayList<String>();
    private final String roomPreface = "room:";
    private final String streamPreface = "stream:";
    private EnxRtc enxRtc;
    private EnxStream localStream;
    private EnxRoom mEnxRoom;
    EnxRN sharedState;
    private String localStreamId;

    public EnxRoomManager(ReactApplicationContext reactContext) {
        super(reactContext);
        sharedState = EnxRN.getSharedState();
        mReactContext = reactContext;
    }

    @ReactMethod
    public void setNativeEvents(ReadableArray events) {
        try {
            for (int i = 0; i < events.size(); i++) {
                jsEvents.add(events.getString(i));
                Log.e("setNativeEvents", jsEvents.get(i).toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @ReactMethod
    public void initRoom() {
        Log.e("EnxRoomManager", "init");
        enxRtc = new EnxRtc(mReactContext.getCurrentActivity(), this, this);
    }

    @ReactMethod
    public void removeNativeEvents(ReadableArray events) {
        for (int i = 0; i < events.size(); i++) {
            jsEvents.remove(events.getString(i));
        }
    }

    @ReactMethod
    public void setJSComponentEvents(ReadableArray events) {
        Log.e("EnxRoomManager", "setJSComponentEvents");
        for (int i = 0; i < events.size(); i++) {
            componentEvents.add(events.getString(i));
        }
    }

    @ReactMethod
    public void removeJSComponentEvents(ReadableArray events) {
        for (int i = 0; i < events.size(); i++) {
            componentEvents.remove(events.getString(i));
        }
    }

    @ReactMethod
    public void joinRoom(String token, ReadableMap localStreamInfo) {
        Log.e("RtcManager", localStreamInfo.toString());
        if (enxRtc != null) {
            localStream = enxRtc.joinRoom(token, getLocalStreamJsonObject(localStreamInfo));
        }
    }

    @ReactMethod
    public void muteSelfAudio(String localStreamId, boolean value) {
        Log.e("muteSelf", "JAVA");
        ConcurrentHashMap<String, EnxStream> mLocalStream = sharedState.getLocalStream();
        EnxStream stream = mLocalStream.get(localStreamId);
        if (value) {
            stream.muteSelfAudio(!value);
        } else {
            stream.muteSelfAudio(!value);
        }
    }

    @ReactMethod
    public void muteSelfVideo(String localStreamId, boolean value) {
        Log.e("muteSelfVideo", "JAVA");
        ConcurrentHashMap<String, EnxStream> mLocalStream = sharedState.getLocalStream();
        EnxStream stream = mLocalStream.get(localStreamId);
        if (value) {
            stream.muteSelfVideo(!value);
        } else {
            stream.muteSelfVideo(!value);
        }
    }

    @ReactMethod
    public void initStream(String streamId) {
        Log.e("initStream", streamId);
        ConcurrentHashMap<String, EnxStream> mEnxStream = sharedState.getLocalStream();
        if (localStream != null) {
            mEnxStream.put(streamId, localStream);
            localStreamId = streamId;
        }
    }

    @ReactMethod
    public void connect(String token) {
        enxRtc.joinRoom(token, getLocalStreamJsonObject());
    }

    @ReactMethod
    public void publish() {
        Log.e("EnxRoomManager", "publish");
        if (localStreamId != null) {
            Log.e("EnxRoomManagerPublish", localStreamId);
            ConcurrentHashMap<String, EnxStream> mEnxStream = sharedState.getLocalStream();
            EnxStream localStream = mEnxStream.get(localStreamId);
            mEnxRoom.publish(localStream);
            localStream.setMuteAudioStreamObserver(this);
            localStream.setMuteVideoStreamObserver(this);
        }
    }

    @ReactMethod
    public void subscribe(String streamId, Callback callback) {
        Log.e("EnxRoomManager", "subscribe");
        ConcurrentHashMap<String, EnxStream> mSubscriberStreams = sharedState.getRemoteStream();
        mEnxRoom.subscribe(mSubscriberStreams.get(streamId));
        callback.invoke("Stream subscribed successfully.");
    }

    @ReactMethod
    public void getLocalStreamId(Callback callback) {
        callback.invoke(localStreamId);
    }

    @ReactMethod
    public void switchCamera(String localStreamId) {
        ConcurrentHashMap<String, EnxStream> mLocalStream = sharedState.getLocalStream();
        EnxStream stream = mLocalStream.get(localStreamId);
        stream.switchCamera();
    }

    @ReactMethod
    public void startRecord() {
        if (mEnxRoom != null) {
            mEnxRoom.startRecord();
        }
    }

    @ReactMethod
    public void stopRecord() {
        if (mEnxRoom != null) {
            mEnxRoom.stopRecord();
        }
    }

    @ReactMethod
    public void getDevices(Callback callback) {
        if (mEnxRoom != null) {
            ArrayList<String> deviceList = (ArrayList<String>) mEnxRoom.getDevices();
            WritableArray array = Arguments.createArray();
            for (int i = 0; i < deviceList.size(); i++) {
                Object value = deviceList.get(i).trim();
                if (value instanceof String) {
                    array.pushString(deviceList.get(i));
                } else if (value == null) {
                    array.pushNull();
                }
            }
            callback.invoke(array);
        }
    }

    @ReactMethod
    public void getSelectedDevice(Callback callback) {
        if (mEnxRoom != null) {
            callback.invoke(mEnxRoom.getSelectedDevice());
        }
    }

    @ReactMethod
    public void getMaxTalkers() {
        if (mEnxRoom != null) {
            mEnxRoom.getMaxTalkers();
        }
    }

    @ReactMethod
    public void getTalkerCount() {
        if (mEnxRoom != null) {
            mEnxRoom.getTalkerCount();
        }
    }

    @ReactMethod
    public void setTalkerCount(int number) {
        if (mEnxRoom != null) {
            mEnxRoom.setTalkerCount(number);
        }
    }

    @ReactMethod
    public void muteRoom() {
        if (mEnxRoom != null) {
            mEnxRoom.muteRoom();
        }
    }

    @ReactMethod
    public void unMuteRoom() {
        if (mEnxRoom != null) {
            mEnxRoom.unMuteRoom();
        }
    }

    @ReactMethod
    public void enableLogs(boolean status) {
        EnxLogsUtil enxLogsUtil = EnxLogsUtil.getInstance();
        enxLogsUtil.enableLogs(status);
    }

    @ReactMethod
    public void switchMediaDevice(String audioDevice) {
        if (mEnxRoom != null) {
            mEnxRoom.switchMediaDevice(audioDevice);
        }
    }

    @ReactMethod
    public void requestFloor() {
        if (mEnxRoom != null) {
            mEnxRoom.requestFloor();
        }
    }

    @ReactMethod
    public void grantFloor(String clientId) {
        if (mEnxRoom != null) {
            mEnxRoom.grantFloor(clientId);
        }
    }

    @ReactMethod
    public void denyFloor(String clientId) {
        if (mEnxRoom != null) {
            mEnxRoom.denyFloor(clientId);
        }
    }

    @ReactMethod
    public void releaseFloor(String clientId) {
        if (mEnxRoom != null) {
            mEnxRoom.releaseFloor(clientId);
        }
    }

    @ReactMethod
    public void postClientLogs() {
        if (mEnxRoom != null) {
            mEnxRoom.postClientLogs();
        }
    }

    @ReactMethod
    public void hardMuteAudio(String streamId, String clientId) {
        Log.e("hardMuteAudio", "");
        ConcurrentHashMap<String, EnxStream> mEnxStream = sharedState.getLocalStream();
        EnxStream localStream = mEnxStream.get(streamId);
        localStream.hardMuteAudio(clientId);
    }

    @ReactMethod
    public void hardUnMuteAudio(String streamId, String clientId) {
        Log.e("hardUnMuteAudio", "");
        ConcurrentHashMap<String, EnxStream> mEnxStream = sharedState.getLocalStream();
        EnxStream localStream = mEnxStream.get(streamId);
        localStream.hardUnMuteAudio(clientId);
    }

    @ReactMethod
    public void hardMuteVideo(String streamId, String clientId) {
        Log.e("hardMuteVideo", "");
        ConcurrentHashMap<String, EnxStream> mEnxStream = sharedState.getLocalStream();
        EnxStream localStream = mEnxStream.get(streamId);
        localStream.hardMuteVideo(clientId);
    }

    @ReactMethod
    public void hardUnMuteVideo(String streamId, String clientId) {
        Log.e("hardUnMuteVideo", "");
        ConcurrentHashMap<String, EnxStream> mEnxStream = sharedState.getLocalStream();
        EnxStream localStream = mEnxStream.get(streamId);
        localStream.hardUnMuteVideo(clientId);
    }

    @ReactMethod
    public void onPause(boolean videoMuteRemoteStream, boolean videoMuteLocalStream) {
        if (mEnxRoom != null) {
            mEnxRoom.onPause(videoMuteRemoteStream, videoMuteLocalStream);
//            enxRoom.onPause(true,true);
        }
    }

    @ReactMethod
    public void onResume(boolean restoreVideoRemoteStream, boolean restoreVideoLocalStream) {
        if (mEnxRoom != null) {
            mEnxRoom.onResume(restoreVideoRemoteStream, restoreVideoLocalStream);
//            enxRoom.onResume(true,true);
        }
    }

    @ReactMethod
    public void disconnect() {
        if (mEnxRoom != null) {
            ConcurrentHashMap<String, EnxPlayerView> playerView = sharedState.getPlayerView();
            for (String key : playerView.keySet()) {
                Log.e("disconnectLocalPlayer", key);
                if (key.length() > 1) {
                    EnxPlayerView playerView1 = playerView.get(key);
                    if (playerView1 != null) {
                        playerView1.release();
                        playerView1 = null;
                    }
                }
            }
            ConcurrentHashMap<String, EnxPlayerView> remotePlayerView = sharedState.getPlayerView();
            for (String key : playerView.keySet()) {
                Log.e("disconnectRemotePlayer", key);
                if (key.length() == 1) {
                    EnxPlayerView playerView1 = remotePlayerView.get(key);
                    if (playerView1 != null) {
                        playerView1.release();
                        playerView1 = null;
                    }
                }
            }
            mEnxRoom.disconnect();
        }
    }

    @Override
    public String getName() {
        return this.getClass().getSimpleName();
    }

    @Override
    public void onRoomConnected(EnxRoom enxRoom, JSONObject jsonObject) {
        Log.e("onRoomConnected", jsonObject.toString());
        mEnxRoom = enxRoom;
        WritableMap payload = Arguments.createMap();
        payload.putString("jsonObject", jsonObject.toString());
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onRoomConnected", payload);
        mEnxRoom.setRecordingObserver(this);
        mEnxRoom.setScreenShareObserver(this);
        mEnxRoom.setTalkerObserver(this);
        mEnxRoom.setLogsObserver(this);
        mEnxRoom.setChairControlObserver(this);
        mEnxRoom.setMuteRoomObserver(this);
    }

    @Override
    public void onRoomError(JSONObject jsonObject) {
        Log.e("onRoomError", jsonObject.toString());
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putInt("errorCode", jsonObject.optInt("errorCode"));
        streamInfo.putString("msg", jsonObject.optString("msg"));
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onRoomError", streamInfo);
    }

    @Override
    public void onUserConnected(JSONObject jsonObject) {
        Log.e("onUserConnected", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSUserMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onUserConnected", streamInfo);
    }

    @Override
    public void onUserDisConnected(JSONObject jsonObject) {
        Log.e("onUserDisConnected", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSUserMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onUserDisConnected", streamInfo);
    }

    @Override
    public void onPublishedStream(EnxStream enxStream) {
        Log.e("onPublishedStream", enxStream.toString());
        WritableMap streamInfo = EnxUtils.customJSONObject("The stream has been published.", "0", localStreamId);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onPublishedStream", streamInfo);
    }

    @Override
    public void onUnPublishedStream(EnxStream enxStream) {
        Log.e("onUnPublishedStream", enxStream.toString());
    }

    @Override
    public void onStreamAdded(EnxStream enxStream) {
        Log.e("onStreamAdded", enxStream.toString());
        ConcurrentHashMap<String, EnxStream> mSubscriberStreams = sharedState.getRemoteStream();
        mSubscriberStreams.put(enxStream.getId(), enxStream);
        WritableMap streamInfo = EnxUtils.prepareJSStreamMap(enxStream);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onStreamAdded", streamInfo);
    }

    @Override
    public void onSubscribedStream(EnxStream enxStream) {
        Log.e("onSubscribedStream", enxStream.toString());
        ConcurrentHashMap<String, EnxStream> mSubscriberStreams = sharedState.getRemoteStream();
        mSubscriberStreams.put(enxStream.getId(), enxStream);
        WritableMap streamInfo = EnxUtils.prepareJSStreamMap(enxStream);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onSubscribedStream", streamInfo);
    }

    @Override
    public void onUnSubscribedStream(EnxStream enxStream) {
        Log.e("onSubscribedStream", enxStream.toString());
    }

    @Override
    public void onRemovedStream(EnxStream enxStream) {
        Log.e("onRemovedStream", enxStream.toString());
    }

    @Override
    public void onRoomDisConnected(JSONObject jsonObject) {
        Log.e("onRoomDisConnected", jsonObject.toString());
        ConcurrentHashMap<String, EnxStream> mLocalStream = sharedState.getLocalStream();
        for (String key : mLocalStream.keySet()) {
            EnxStream stream = mLocalStream.get(key);
            stream.detachRenderer();
        }
        if (mEnxRoom != null) {
            mEnxRoom = null;
        }
        if (enxRtc != null) {
            enxRtc = null;
        }
        Log.e("onRoomDisConnected", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onRoomDisConnected", streamInfo);
    }

    @Override
    public void onActiveTalkerList(JSONObject jsonObject) {
        Log.e("onActiveTalkerList", jsonObject.toString());
        if (jsonObject.optString("active").equalsIgnoreCase("false")) {
            return;
        }
//            WritableMap streamInfo = EnxUtils.prepareJSActiveListMap(jsonObject.optJSONArray("activeList"));
        try {
            sendEventMapArray(this.getReactApplicationContext(), roomPreface + "onActiveTalkerList", convertJsonToArray(jsonObject.optJSONArray("activeList")));
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onEventError(JSONObject jsonObject) {
        Log.e("onEventError", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSErrorMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onEventError", streamInfo);
    }

    @Override
    public void onNotifyDeviceUpdate(String s) {
        Log.e("onNotifyDeviceUpdate", s);
    }

    @Override
    public void onCanvasStarted(JSONObject jsonObject) {
        Log.e("onCanvasStarted", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSShareStreamMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onCanvasStarted", streamInfo);
    }

    @Override
    public void onCanvasStopped(JSONObject jsonObject) {
        Log.e("onCanvasStopped", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSShareStreamMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onCanvasStopped", streamInfo);
    }

    @Override
    public void onDeviceAdded(String s) {
        Log.e("onDeviceAdded", s);
    }

    @Override
    public void onDeviceRemoved(String s) {
        Log.e("onDeviceRemoved", s);
    }

    @Override
    public void onAudioEvent(JSONObject jsonObject) {
        Log.e("onAudioEvent", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSErrorMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onAudioEvent", streamInfo);
    }

    @Override
    public void onVideoEvent(JSONObject jsonObject) {
        Log.e("onVideoEvent", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSErrorMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onVideoEvent", streamInfo);
    }

    @Override
    public void onReceivedData(JSONObject jsonObject) {
        Log.e("onReceivedData", jsonObject.toString());
    }

    @Override
    public void onRemoteStreamAudioMute(JSONObject jsonObject) {
        Log.e("onRemoteStreamAudioMute", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSCCResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onRemoteStreamAudioMute", streamInfo);
    }

    @Override
    public void onRemoteStreamAudioUnMute(JSONObject jsonObject) {
        Log.e("onRemoteStrmAudioUnMute", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSCCResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onRemoteStreamAudioUnMute", streamInfo);
    }

    @Override
    public void onRemoteStreamVideoMute(JSONObject jsonObject) {
        Log.e("onRemoteStrmAudioUnMute", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSCCResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onRemoteStreamVideoMute", streamInfo);
    }

    @Override
    public void onRemoteStreamVideoUnMute(JSONObject jsonObject) {
        Log.e("onRemoteStrmVideoUnMute", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSCCResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onRemoteStreamVideoUnMute", streamInfo);
    }

    @Override
    public void onStartRecordingEvent(JSONObject jsonObject) {
        Log.e("onStartRecordingEvent", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onStartRecordingEvent", streamInfo);
    }

    @Override
    public void onRoomRecordingOn(JSONObject jsonObject) {
        Log.e("onRoomRecordingOn", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onRoomRecordingOn", streamInfo);
    }

    @Override
    public void onStopRecordingEvent(JSONObject jsonObject) {
        Log.e("onStopRecordingEvent", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onStopRecordingEvent", streamInfo);
    }

    @Override
    public void onRoomRecordingOff(JSONObject jsonObject) {
        Log.e("onRoomRecordingOff", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onRoomRecordingOff", streamInfo);
    }

    @Override
    public void onScreenSharedStarted(JSONObject jsonObject) {
        Log.e("onScreenSharedStarted", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSShareStreamMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onScreenSharedStarted", streamInfo);
    }

    @Override
    public void onScreenSharedStopped(JSONObject jsonObject) {
        Log.e("onScreenSharedStopped", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSShareStreamMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onScreenSharedStopped", streamInfo);
    }

    @Override
    public void onSetTalkerCount(JSONObject jsonObject) {
        Log.e("onSetTalkerCount", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSTalkerMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onSetTalkerCount", streamInfo);
    }

    @Override
    public void onGetTalkerCount(JSONObject jsonObject) {
        Log.e("onGetTalkerCount", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSTalkerMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onGetTalkerCount", streamInfo);
    }

    @Override
    public void onMaxTalkerCount(JSONObject jsonObject) {
        Log.e("onMaxTalkerCount", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSTalkerMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onMaxTalkerCount", streamInfo);
    }

    @Override
    public void onLogUploaded(JSONObject jsonObject) {
        Log.e("onLogUploaded", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onLogUploaded", streamInfo);
    }

    @Override
    public void onFloorRequested(JSONObject jsonObject) {
        Log.e("onFloorRequested", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onFloorRequested", streamInfo);
    }

    @Override
    public void onFloorRequestReceived(JSONObject jsonObject) {
        Log.e("onFloorRequestReceived", jsonObject.toString());
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putString("clientId", jsonObject.optString("clientId"));
        streamInfo.putString("name", jsonObject.optString("name"));
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onFloorRequestReceived", streamInfo);
    }

    @Override
    public void onProcessFloorRequested(JSONObject jsonObject) {
        Log.e("onProcessFloorRequested", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onProcessFloorRequested", streamInfo);
    }

    @Override
    public void onGrantedFloorRequest(JSONObject jsonObject) {
        Log.e("onGrantedFloorRequest", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSCCResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onGrantedFloorRequest", streamInfo);
    }

    @Override
    public void onDeniedFloorRequest(JSONObject jsonObject) {
        Log.e("onDeniedFloorRequest", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSCCResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onDeniedFloorRequest", streamInfo);
    }

    @Override
    public void onReleasedFloorRequest(JSONObject jsonObject) {
        Log.e("onReleasedFloorRequest", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSCCResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onReleasedFloorRequest", streamInfo);
    }

    @Override
    public void onMutedRoom(JSONObject jsonObject) {
        Log.e("onMutedRoom", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onMutedRoom", streamInfo);
    }

    @Override
    public void onReceivedMuteRoom(JSONObject jsonObject) {
        Log.e("onReceivedMuteRoom", jsonObject.toString());
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putBoolean("status", jsonObject.optBoolean("status"));
        streamInfo.putString("msg", jsonObject.optString("msg"));
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onReceivedMuteRoom", streamInfo);
    }

    @Override
    public void onUnMutedRoom(JSONObject jsonObject) {
        Log.e("onUnMutedRoom", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onUnMutedRoom", streamInfo);
    }

    @Override
    public void onReceivedUnMutedRoom(JSONObject jsonObject) {
        Log.e("onReceivedUnMutedRoom", jsonObject.toString());
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putBoolean("status", jsonObject.optBoolean("status"));
        streamInfo.putString("msg", jsonObject.optString("msg"));
        sendEventMap(this.getReactApplicationContext(), roomPreface + "onReceivedUnMutedRoom", streamInfo);
    }

    @Override
    public void onHardMutedAudio(JSONObject jsonObject) {
        Log.e("onHardMutedAudio", jsonObject.toString());
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putString("result", jsonObject.optString("result"));
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onHardMutedAudio", streamInfo);
    }

    @Override
    public void onHardUnMutedAudio(JSONObject jsonObject) {
        Log.e("onHardUnMutedAudio", jsonObject.toString());
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putString("result", jsonObject.optString("result"));
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onHardUnMutedAudio", streamInfo);
    }

    @Override
    public void onReceivedHardMuteAudio(JSONObject jsonObject) {
        Log.e("onReceivedHardMuteAudio", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSCCResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onReceivedHardMuteAudio", streamInfo);
    }

    @Override
    public void onReceivedHardUnMuteAudio(JSONObject jsonObject) {
        Log.e("onReceveHardUnMuteAudio", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSCCResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onReceivedHardUnMuteAudio", streamInfo);
    }

    @Override
    public void onHardMutedVideo(JSONObject jsonObject) {
        Log.e("onHardMutedVideo", jsonObject.toString());
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putString("result", jsonObject.optString("result"));
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onHardMutedVideo", streamInfo);
    }

    @Override
    public void onHardUnMutedVideo(JSONObject jsonObject) {
        Log.e("onHardUnMutedVideo", jsonObject.toString());
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putString("result", jsonObject.optString("result"));
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onHardUnMutedVideo", streamInfo);
    }

    @Override
    public void onReceivedHardMuteVideo(JSONObject jsonObject) {
        Log.e("onReceivedHardMuteVideo", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSCCResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onReceivedHardMuteVideo", streamInfo);
    }

    @Override
    public void onReceivedHardUnMuteVideo(JSONObject jsonObject) {
        Log.e("onReceivHardUnMuteVideo", jsonObject.toString());
        WritableMap streamInfo = EnxUtils.prepareJSCCResultMap(jsonObject);
        sendEventMap(this.getReactApplicationContext(), streamPreface + "onReceivedHardUnMuteVideo", streamInfo);
    }

    public static WritableArray convertJsonToArray(JSONArray jsonArray) throws JSONException {
        WritableArray writableArray = Arguments.createArray();
        for (int i = 0; i < jsonArray.length(); i++) {
            Object value = jsonArray.get(i);
            if (value instanceof Float || value instanceof Double) {
                writableArray.pushDouble(jsonArray.getDouble(i));
            } else if (value instanceof Number) {
                writableArray.pushInt(jsonArray.getInt(i));
            } else if (value instanceof String) {
                writableArray.pushString(jsonArray.getString(i));
            } else if (value instanceof JSONObject) {
                writableArray.pushMap(jsonToReact(jsonArray.getJSONObject(i)));
            } else if (value instanceof JSONArray) {
                writableArray.pushArray(convertJsonToArray(jsonArray.getJSONArray(i)));
            } else if (value == JSONObject.NULL) {
                writableArray.pushNull();
            }
        }
        return writableArray;
    }

    public static WritableMap jsonToReact(JSONObject jsonObject) throws JSONException {
        WritableMap writableMap = Arguments.createMap();
        Iterator iterator = jsonObject.keys();
        while (iterator.hasNext()) {
            String key = (String) iterator.next();
            Object value = jsonObject.get(key);
            if (value instanceof Float || value instanceof Double) {
                writableMap.putDouble(key, jsonObject.getDouble(key));
            } else if (value instanceof Number) {
                writableMap.putInt(key, jsonObject.getInt(key));
            } else if (value instanceof String) {
                writableMap.putString(key, jsonObject.getString(key));
            } else if (value instanceof JSONObject) {
                writableMap.putMap(key, jsonToReact(jsonObject.getJSONObject(key)));
            } else if (value instanceof JSONArray) {
                writableMap.putArray(key, convertJsonToArray(jsonObject.getJSONArray(key)));
            } else if (value == JSONObject.NULL) {
                writableMap.putNull(key);
            }
        }

        return writableMap;
    }

    private JSONObject getLocalStreamJsonObject() {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("audio", true);
            jsonObject.put("video", true);
            jsonObject.put("data", true);
            jsonObject.put("maxVideoBW", 400);
            jsonObject.put("minVideoBW", 300);
            JSONObject videoSize = new JSONObject();
            videoSize.put("minWidth", 720);
            videoSize.put("minHeight", 480);
            videoSize.put("maxWidth", 1280);
            videoSize.put("maxHeight", 720);
            jsonObject.put("videoSize", videoSize);
            jsonObject.put("audioMuted", "true");
            jsonObject.put("videoMuted", "true");
            jsonObject.put("name", "ReactNative");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject;
    }

    private JSONObject getLocalStreamJsonObject(ReadableMap localStreamInfo) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("audio", localStreamInfo.getBoolean("audio"));
            jsonObject.put("video", localStreamInfo.getBoolean("video"));
            jsonObject.put("data", localStreamInfo.getBoolean("data"));
            jsonObject.put("maxVideoBW", localStreamInfo.getString("maxVideoBW"));
            jsonObject.put("minVideoBW", localStreamInfo.getString("minVideoBW"));
            JSONObject videoSize = new JSONObject();
            videoSize.put("minWidth", localStreamInfo.getString("minWidth"));
            videoSize.put("minHeight", localStreamInfo.getString("minHeight"));
            videoSize.put("maxWidth", localStreamInfo.getString("maxWidth"));
            videoSize.put("maxHeight", localStreamInfo.getString("maxHeight"));
            jsonObject.put("videoSize", videoSize);
            jsonObject.put("audioMuted", localStreamInfo.getBoolean("audioMuted"));
            jsonObject.put("videoMuted", localStreamInfo.getBoolean("videoMuted"));
            jsonObject.put("name", localStreamInfo.getString("name"));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject;
    }

    public static boolean contains(ArrayList array, String value) {
        for (int i = 0; i < array.size(); i++) {
            if (array.get(i).equals(value)) {
                return true;
            }
        }
        return false;
    }

    private void sendEventMapArray(ReactContext reactContext, String eventName, @Nullable WritableArray eventData) {
        if (contains(jsEvents, eventName) || contains(componentEvents, eventName)) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, eventData);
        }
    }

    private void sendEventMap(ReactContext reactContext, String eventName, @Nullable WritableMap eventData) {
        if (contains(jsEvents, eventName) || contains(componentEvents, eventName)) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, eventData);
        }
    }

    private void sendEventWithString(ReactContext reactContext, String eventName, String eventString) {
        if (contains(jsEvents, eventName) || contains(componentEvents, eventName)) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, eventString);
        }
    }
}
