//
//  EnxRoomManager.swift
//  EnxRtc
//
//  Created by Daljeet Singh on 17/03/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import EnxRTCiOS

@objc(EnxRoomManager)
class EnxRoomManager: RCTEventEmitter {
    private var count = 0
    var localStream : EnxStream!
    var objectJoin: EnxRtc!
    var remoteRoom : EnxRoom!
    var componentEvents: [String] = [];
    var jsEvents: [String] = [];
    
    @objc override func supportedEvents() -> [String] {
        let allEvents = getSupportedEvents();
        return jsEvents + allEvents
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true;
    }
    
    @objc func initRoom(){
        objectJoin = EnxRtc()
    }
    
    @objc func connect(_ token: String){
        let localStreamInfo : NSDictionary = ["video" : true ,"audio" : true ,"data" :true,"usertype":"participant" ,"name" :"ReactNativeiOS","mode" : "group" ,"type" : "public"]
        guard let localStreamObject = self.objectJoin.joinRoom(token, delegate: self, publishStreamInfo: (localStreamInfo as! [AnyHashable : Any])) else{
            return
        }
        self.localStream = localStreamObject
        self.localStream.delegate = self as EnxStreamDelegate
    }
    
    @objc func joinRoom(_ token: String, localInfo: NSDictionary){
        let localStreamInfo : NSDictionary = localInfo
        guard let localStreamObject = self.objectJoin.joinRoom(token, delegate: self, publishStreamInfo: (localStreamInfo as! [AnyHashable : Any])) else{
            return
        }
         self.localStream = localStreamObject
        self.localStream.delegate = self as EnxStreamDelegate
    }
    
    
    @objc func publish(){
        
        guard localStream != nil else{
          return
        }
        EnxRN.sharedState.room!.publish(localStream)
    }
    
    @objc func initStream(_ streamId:String){
        sleep(2)
        guard streamId != nil else{
            return
        }
        if(localStream != nil){
            EnxRN.sharedState.publishStreams.updateValue(localStream, forKey: streamId as String)
            let player : EnxPlayerView = EnxRN.sharedState.players[streamId]!
            localStream.attachRenderer(player)
            EnxRN.sharedState.publishStreams.updateValue(localStream, forKey: streamId)
        }
       
    }
    
    
    @objc func getLocalStreamId(_ callback: @escaping RCTResponseSenderBlock) -> Void {
        let streamDict = EnxRN.sharedState.publishStreams
        var keyString: String = ""
        for (key, _) in streamDict {
           keyString = key
        }
          callback([keyString])
    }
    
    @objc func subscribe(_ streamId: String, callback: @escaping RCTResponseSenderBlock) -> Void {
        if(streamId == nil){
            callback(["Error"])
        }
        let stream =  EnxRN.sharedState.room?.streamsByStreamId![streamId] as! EnxStream
        EnxRN.sharedState.room!.subscribe(stream)
        self.emitEvent(event: "room:didSubscribedStream", data: "Subscribed")
        
    }
    
    
    @objc func switchCamera(_ streamId: String){
        
        let stream =  EnxRN.sharedState.publishStreams[streamId] as! EnxStream
        if(stream == nil){
            return
        }
        else{
           stream.switchCamera()
        }
    }
    
    @objc func muteSelfAudio(_ streamId: String, value: Bool){
        
        let stream =  EnxRN.sharedState.publishStreams[streamId]
        if(stream == nil){
            return
        }
        else{
            stream?.muteSelfAudio(value)
        }
        
    }
    
    @objc func muteSelfVideo(_ streamId: String, value: Bool){
        
        let stream =  EnxRN.sharedState.publishStreams[streamId]
        if(stream == nil){
            return
        }
        else{
            stream?.muteSelfVideo(value)
        }
        
    }
    
    
    @objc func startRecord(){
        let room =  EnxRN.sharedState.room
        if(room == nil){
            return
        }
        else{
            room?.startRecord()
        }
    }
    
    @objc func stopRecord(){
        let room =  EnxRN.sharedState.room
        if(room == nil){
            return
        }
        else{
            room?.stopRecord()
        }
    }
    
    //Chair Control
    //For Participant
    @objc func requestFloor(){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        
        room .requestFloor()
    }
    
    //For Moderator
    @objc func grantFloor(_ clientId: String){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        if clientId.count > 0{
            room.grantFloor(clientId)
        }
    }
    
    @objc func denyFloor(_ clientId: String){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        if clientId.count > 0{
            room.denyFloor(clientId)
        }
    }
    
    @objc func releaseFloor(_ clientId: String){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        if clientId.count > 0{
            room.releaseFloor(clientId)
        }
    }
    
    //Hard Mute
    
    @objc func hardMuteAudio(_ streamId: String, _ clientId: String){
        let stream =  EnxRN.sharedState.publishStreams[streamId]
        if(stream == nil){
            return
        }
        else{
            if clientId.count > 0{
                stream?.hardMuteAudio(clientId)
            }
        }
    }
    
    @objc func hardUnmuteAudio(_ streamId: String, _ clientId: String){
        let stream =  EnxRN.sharedState.publishStreams[streamId]
        if(stream == nil){
            return
        }
        else{
            if clientId.count > 0{
                stream?.hardUnMuteAudio(clientId)
            }
        }
    }
    
    @objc func hardMuteVideo(_ streamId: String, _ clientId: String){
        let stream =  EnxRN.sharedState.publishStreams[streamId]
        if(stream == nil){
            return
        }
        else{
            if clientId.count > 0{
                stream?.hardMuteVideo(clientId)
            }
        }
    }
    
    @objc func hardUnmuteVideo(_ streamId: String, _ clientId: String){
        let stream =  EnxRN.sharedState.publishStreams[streamId]
        if(stream == nil){
            return
        }
        else{
            if clientId.count > 0{
                stream?.hardUnMuteVideo(clientId)
            }
        }
    }
    
    //Hard Room mute
    @objc func muteAllUser(){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.muteAllUser()
    }
    
    @objc func unMuteAllUser(){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.unMuteAllUser()
    }
    
    @objc func sendData(_ streamId: String, _ data: NSDictionary){
        let stream =  EnxRN.sharedState.publishStreams[streamId]
        if(stream == nil){
            return
        }
        else{
            stream?.sendData(data as! [AnyHashable : Any])
        }
    }
    
    //Post Client Logs
    // To enble Enx logs to write in the file.
    @objc func enableLogs(_ value: Bool)
    {
        if(value){
            let enxLog = EnxLogger.sharedInstance()
            enxLog?.startLog()
        }
        else{
            
        }
    }
    
    @objc func postClientLogs(){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.postClientLogs()
    }
    
    @objc func enableStats(_ value: Bool)
    {
        guard let room = EnxRN.sharedState.room else {
            return
        }
            room.publishingStats = value
    }
    
    // Set Active Talker Count
    @objc func setTalkerCount(_ number: Int){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.setTalkerCount(number)
    }
    
    @objc func getTalkerCount(){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.getTalkerCount()
    }
    
    @objc func getMaxTalkers(){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.getMaxTalkers()
    }
    
    @objc func changeToAudioOnly(_ value:Bool){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.change(toAudioOnly: value)
    }
    
    @objc func muteRemoteStreamInBacground(_ value: Bool){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.applicationDidEnterBackground(value)
    }
    
    @objc func muteRemoteStreamInForeground(_ value: Bool){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.applicationWillEnterForeground(value)
    }
    
    //Audio Device methods
    @objc func switchMediaDevice(_ mediaName: String){
        guard let room = EnxRN.sharedState.room else{
            return
        }
            room.switchMediaDevice(mediaName)
    }
    
    @objc func getSelectedDevice(_ callback: @escaping RCTResponseSenderBlock) -> Void {
        guard let room = EnxRN.sharedState.room else{
            return
        }
        
        let selectedDeviceString : String = room.getSelectedDevice()
        let selectedDeviceArray = [selectedDeviceString]
        callback(selectedDeviceArray)
    }
    
    @objc func getDevices(_ callback: @escaping RCTResponseSenderBlock) -> Void {
        guard let room = EnxRN.sharedState.room else{
            return
        }
       let deviceArray = room.getDevices()
        callback(deviceArray)
        
    }
    
    
    @objc func disconnect(){
        
        let room =  EnxRN.sharedState.room
        if(room == nil){
            return
        }
        else{
            room?.disconnect()
        }
    }
    
    @objc func setNativeEvents(_ events: Array<String>) -> Void {
        for event in events {
            if (!self.jsEvents.contains(event)) {
                self.jsEvents.append(event);
            }
        }
    }
    
    @objc func removeNativeEvents(_ events: Array<String>) -> Void {
        for event in events {
            if let i = self.jsEvents.index(of: event) {
                self.jsEvents.remove(at: i)
            }
        }
    }
   
    
    @objc func setJSComponentEvents(_ events: Array<String>) -> Void {
        for event in events {
            self.componentEvents.append(event);
        }
    }
    
    @objc func removeJSComponentEvents(_ events: Array<String>) -> Void {
        for event in events {
            if let i = self.componentEvents.index(of: event) {
                self.componentEvents.remove(at: i)
            }
        }
    }

    
    func emitEvent(event : String , data: Any) -> Void {
        if (self.jsEvents.contains(event) || self.componentEvents.contains(event)) {
            self.sendEvent(withName: event, body: data);
        }
    }
}


extension EnxRoomManager : EnxRoomDelegate, EnxStreamDelegate,EnxRoomStatsDelegate
{
    func getSupportedEvents() -> [String] {
        
        return ["room:didActiveTalkerList","room:didScreenSharedStarted","room:didScreenShareStopped","room:didCanvasStarted","room:didCanvasStopped","room:didRoomRecordStart","room:didRoomRecordStop","room:didFloorRequested","room:didLogUpload","room:publishStats","room:subscribeStats","room:didSetTalkerCount","room:didGetMaxTalkers","room:didGetTalkerCount","room:userDidConnected","room:userDidDisconnected","stream:didAudioEvent","stream:didVideoEvent","stream:didhardMuteAudio","stream:didhardUnmuteAudio","stream:didRemoteStreamAudioMute","stream:didRemoteStreamAudioUnMute","stream:didRemoteStreamVideoMute","stream:didRecievedHardMutedAudio","stream:didRecievedHardUnmutedAudio","stream:didRemoteStreamVideoUnMute","stream:didHardVideoMute","stream:didHardVideoUnMute","stream:didReceivehardMuteVideo","stream:didRecivehardUnmuteVideo","stream:didReceiveData"];
    }
    
    
    func room(_ room: EnxRoom?, didConnect roomMetadata: [AnyHashable : Any]?) {
        EnxRN.sharedState.room = room
        self.emitEvent(event: "room:didRoomConnected", data: roomMetadata as Any)
    }
    
    func room(_ room: EnxRoom?, didError reason: String?) {
        guard let errorVal = reason else{
            return
        }
        self.emitEvent(event: "room:didError", data: errorVal)
    }

    func room(_ room: EnxRoom?, didEventError reason: [Any]?) {
        print(reason as Any);
        guard let resDict = reason?[0] as? [String : Any], reason!.count > 0 else{
            return
        }
        self.emitEvent(event: "room:didEventError", data:resDict)
    }

    func room(_ room: EnxRoom?, didPublishStream stream: EnxStream?) {
       
        guard let localStream = stream else{
            return
        }
        let resultDict : NSDictionary = ["result" : 0 ,"message" : "Stream has been published." ,"streamId" :localStream.streamId as Any]
        
        self.emitEvent(event: "room:didPublishedStream", data: resultDict)
    }
    
    func room(_ room: EnxRoom?, didAddedStream stream: EnxStream?) {
        
        guard stream != nil else{
            return
        }
        EnxRN.sharedState.subscriberStreams.updateValue(stream!, forKey: stream?.streamId as! String)
        let resultDict : NSDictionary = ["streamId" : stream!.streamId as Any ,"hasData" : stream?.hasData() as Any  ,"hasScreen" :stream?.screen as Any]
        self.emitEvent(event: "room:didStreamAdded", data: resultDict)
    }
    
    func room(_ room: EnxRoom?, didSubscribeStream stream: EnxStream?) {
        guard let player = EnxRN.sharedState.players[(stream?.streamId)!] else {
            return
        }
        stream?.attachRenderer(player)
        self.emitEvent(event: "room:didSubscribedStream", data: "")
    }
    
    func room(_ room: EnxRoom?, activeTalkerList Data: [Any]?) {
        
        guard let tempDict = Data?[0] as? [String : Any], Data!.count>0 else {
            
            return
        }
        let activeListArray = tempDict["activeList"] as? [Any]
        //        let resultDict : NSDictionary = ["streamId" : stream.streamId as Any ,"hasData" : stream.hasData() as Any  ,"hasScreen" :stream.screen as Any]
        self.emitEvent(event: "room:didActiveTalkerList", data: activeListArray)
        
        for (index,active) in (activeListArray?.enumerated())! {
            // Do this
            let remoteStreamDict = EnxRN.sharedState.room!.streamsByStreamId as! [String : Any]
            let mostActiveDict = active as! [String : Any]
            let streamId = String(mostActiveDict["streamId"] as! Int)
            let stream = remoteStreamDict[streamId] as! EnxStream
            
            guard let player = EnxRN.sharedState.players[streamId] else{
                return
            }
            stream.attachRenderer(player)
        }
    }
    
    //Screen Share Delegates
    func room(_ room: EnxRoom?, screenSharedStarted Data: [Any]?) {
        guard let shareDict = Data?[0] as? [String : Any], Data!.count > 0 else{
            return
        }
        self.emitEvent(event: "room:didScreenSharedStarted", data:shareDict)
        let streamId = String (shareDict["streamId"] as! Int)
        let shareStream = EnxRN.sharedState.room!.streamsByStreamId![streamId] as! EnxStream
        guard let player = EnxRN.sharedState.players[streamId] else{
            return
        }
        shareStream.attachRenderer(player)
        
    }
    
    func room(_ room: EnxRoom?, screenShareStopped Data: [Any]?) {
        guard let shareDict = Data?[0] as? [String : Any], Data!.count > 0 else{
            return
        }
        self.emitEvent(event: "room:didScreenShareStopped", data: shareDict)
    }
    
    //Canvas Delegates
    func room(_ room: EnxRoom?, canvasStarted Data: [Any]?) {
        guard let canvasDict = Data?[0] as? [String : Any], Data!.count > 0 else{
            return
        }
        self.emitEvent(event: "room:didCanvasStarted", data:canvasDict)
        let streamId = String (canvasDict["streamId"] as! Int)
        let canvasStream = EnxRN.sharedState.room!.streamsByStreamId![streamId] as! EnxStream
        guard let player = EnxRN.sharedState.players[streamId] else{
            return
        }
        canvasStream.attachRenderer(player)
    }
    
    func room(_ room: EnxRoom?, canvasStopped Data: [Any]?) {
        guard let canvasDict = Data?[0] as? [String : Any], Data!.count > 0 else{
            return
        }
        self.emitEvent(event: "room:didCanvasStopped", data: canvasDict)
    }
    
    func roomDidDisconnected(_ status: EnxRoomStatus) {
       self.emitEvent(event: "room:didDisconnected", data: status)
    }
    
    /* Recording Delegate */
    /* This delegate called when recording started by the moderator. */
    func startRecordingEvent(_ response: [Any]?) {
        guard let responseDict = response?[0] as? [String : Any], response!.count > 0 else{
            return
        }
        self.emitEvent(event: "room:didStartRecordingEvent", data: responseDict)
    }
    /* This delegate called when recording stopped by the moderator. */
    func stopRecordingEvent(_ response: [Any]?) {
        guard let responseDict = response?[0] as? [String : Any], response!.count > 0 else{
            return
        }
        self.emitEvent(event: "room:didStopRecordingEvent", data: responseDict)
    }
    /* When recording is started in the room, (either implicitly or explicitly), all connected users are notified that room is being recorded.(For Participant) */
    func roomRecord(on Data: [Any]?) {
        guard let responseDict = Data?[0] as? [String : Any], Data!.count > 0 else{
            return
        }
        self.emitEvent(event: "room:didRoomRecordStart", data: responseDict)
    }
    
    /* When the recording is turned off (either implicitly or explicitly), all connected users are notified that recording has been stopped in the room.(For Participant) */
    func roomRecordOff(_ Data: [Any]?) {
        guard let responseDict = Data?[0] as? [String : Any], Data!.count > 0 else{
            return
        }
        self.emitEvent(event: "room:didRoomRecordStop", data: responseDict)
    }
    
     /* Chair control Delegates */
    //Participant receives on the success of requestFloor. This is for participant only.
    func didFloorRequested(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didFloorRequested", data: dataDict)
    }
    
    /* Participant receives when the moderator performs action grantFloor. */
    func didGrantFloorRequested(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didGrantFloorRequested", data: dataDict)
    }
    /* Participant receives when the moderator performs action denyFloor. */
    func didDenyFloorRequested(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didDenyFloorRequested", data: dataDict)
    }
    
   /* Participant receives when the moderator performs action releaseFloor. */
    func didReleaseFloorRequested(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didReleaseFloorRequested", data: dataDict)
    }
    
   /* Moderator receives any Floor Request raised by the participant. This is for Moderator only. */
    func didFloorRequestReceived(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didFloorRequestReceived", data: dataDict)
    }
    
    
      /* Moderator receives acknowledgment on performing actions like grantFloor, denyFloor, releaseFloor. */
    func didProcessFloorRequested(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didProcessFloorRequested", data: dataDict)
    }
    
    
    //Room mute Delegates
    /* This delegate called when the room is muted by the moderator. Available to Moderator only. */
    func didMutedAllUser(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didMutedAllUser", data: dataDict)
    }
    
     /* This delegate called when the room is unmuted by the moderator. Available to Moderator only. */
    func didUnMutedAllUser(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didUnMutedAllUser", data: dataDict)
   
    }
    
    /* Participants notified when room is muted by any moderator. */
    func didHardMutedAll(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didHardMutedAll", data: dataDict)
    }
    
    /*  */
    func didHardUnMuteAllUser(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didHardUnMuteAllUser", data: dataDict)
    }
    
    /* This delegate called when a user is connected to a room, all other connected users are notified about the new user. */
    func room(_ room: EnxRoom?, userDidJoined Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:userDidConnected", data: dataDict)
    }
    
    /* When a user is disconnected from a room, all other connected users are notified about the users exit. */
    func room(_ room: EnxRoom?, userDidDisconnected Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:userDidDisconnected", data: dataDict)
    }
    
    //logs upload delegate
    func didLogUpload(_ data: [Any]?) {
        guard let dataDict = data?[0] as? [String : Any], data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didLogUpload", data: dataDict)
    }
    
    //Stats Delegate
    
    func room(_ room: EnxRoom!, publishingClient: EnxClient!, mediaType: String!, ssrc: String!, publishingAtKbps kbps: Int, didReceiveStats statsReport: RTCLegacyStatsReport!) {
        
        let statsDict = ["subscribeClient": publishingClient.streamId,
                         "mediaType": mediaType,
                         "ssrc": ssrc,
                         "kbps": kbps,
                         "statsReport": statsReport]  as [String : Any]
        
        self.emitEvent(event: "room:publishStats", data: statsDict)
    }
    
    func room(_ room: EnxRoom!, subscribeClient: EnxClient!, mediaType: String!, ssrc: String!, subscribeAtKbps kbps: Int, didReceiveStats statsReport: RTCLegacyStatsReport!) {
        
        let statsDict = ["subscribeClient": subscribeClient.streamId,
                    "mediaType": mediaType,
                    "ssrc": ssrc,
                    "kbps": kbps,
                    "statsReport": statsReport]  as [String : Any]
        
        self.emitEvent(event: "room:subscribeStats", data: statsDict)

    }
    
    //Set and Get Active talker Delegates.
    /* Client endpoint receives when the user set number of active talker. */
    func room(_ room: EnxRoom?, didSetTalkerCount Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didSetTalkerCount", data: dataDict)
    }
    
    /* Client endpoint will get the maximum number of allowed Active Talkers in the connected room. */
    func room(_ room: EnxRoom?, didGetMaxTalkers Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didGetMaxTalkers", data: dataDict)
    }
    
    /* Client endpoint receives when the user request to get opted active talker streams set by them. */
    func room(_ room: EnxRoom?, didGetTalkerCount Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didGetTalkerCount", data: dataDict)
    }
    
    
    /* Stream Delegates */
    
    func didAudioEvents(_ data: [AnyHashable : Any]?) {
        let modifiedDict = ["msg": data?["message"] as Any,
                            "result": data?["code"] as Any,
                            ]  as [String : Any]
        self.emitEvent(event: "stream:didAudioEvent", data: modifiedDict as Any)
    }
    
   
    func didVideoEvents(_ data: [AnyHashable : Any]?) {
        var messageString = ""
        if data?["message"] as! String == "Unmute" {
            messageString = "Video on"
        }
        else{
            messageString = "Video off"
        }
        let modifiedDict = ["msg": messageString as Any,
                            "result": data?["code"] as Any,
                        ]  as [String : Any]
        
        self.emitEvent(event: "stream:didVideoEvent", data: modifiedDict as Any)
    }
    
    //Receive all other users
    func stream(_ stream: EnxStream?, didSelfMuteAudio data: [Any]?) {
        guard let dataDict = data?[0] as? [String : Any], data!.count>0 else {
            return
        }
        self.emitEvent(event: "stream:didRemoteStreamAudioMute", data: dataDict)
    }
    
    //Receive all other users
    func stream(_ stream: EnxStream?, didSelfUnmuteAudio data: [Any]?) {
        guard let dataDict = data?[0] as? [String : Any], data!.count>0 else {
            return
        }
        self.emitEvent(event: "stream:didRemoteStreamAudioUnMute", data: dataDict)
    }
    
    //Receive all other users
    func stream(_ stream: EnxStream?, didSelfMuteVideo data: [Any]?) {
        guard let dataDict = data?[0] as? [String : Any], data!.count>0 else {
            return
        }
        self.emitEvent(event: "stream:didRemoteStreamVideoMute", data: dataDict)
    }
    
    // Receive all other users
    func stream(_ stream: EnxStream?, didSelfUnmuteVideo data: [Any]?) {
        guard let dataDict = data?[0] as? [String : Any], data!.count>0 else {
            return
        }
        self.emitEvent(event: "stream:didRemoteStreamVideoUnMute", data: dataDict)
    }
    
    //Hard mute Delegate
    /* On Success of single user mute by moderator. This delegate method is for moderator.*/
    func didhardMuteAudio(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "stream:didhardMuteAudio", data: dataDict)
    }
    
    /*On Success of single user unmute by moderator. This delegate method is for moderator.*/
    func didhardUnMuteAudio(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "stream:didhardUnmuteAudio", data: dataDict)
    }
    
    /*On Success of single user mute by moderator. This delegate method is for participant.*/
    func didRecievedHardMutedAudio(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "stream:didRecievedHardMutedAudio", data: dataDict)
        
    }
    
    /*On Success of single user unmute by moderator. This delegate method is for participant.*/
    func didRecievedHardUnmutedAudio(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "stream:didRecievedHardUnmutedAudio", data: dataDict)
        
    }
    
    //For Video
    /* This delegate called when a hard mute video alert moderator received from server. This delegate is for moderator. */
    func stream(_ stream: EnxStream?, didHardVideoMute data: [Any]?) {
        guard let dataDict = data?[0] as? [String : Any], data!.count>0 else {
            return
        }
        self.emitEvent(event: "stream:didHardVideoMute", data: dataDict)
    }
    
    /* This delegate called when a hard unmute video alert moderator received from server. This delegate is for moderator. */
    func stream(_ stream: EnxStream?, didHardVideoUnMute data: [Any]?) {
        guard let dataDict = data?[0] as? [String : Any], data!.count>0 else {
            return
        }
        self.emitEvent(event: "stream:didHardVideoUnMute", data: dataDict)
    }
    
    /* This delegate called when a hard mute video alert participant received from server. */
    func stream(_ stream: EnxStream?, didReceivehardMuteVideo data: [Any]?) {
        guard let dataDict = data?[0] as? [String : Any], data!.count>0 else {
            return
        }
        self.emitEvent(event: "stream:didReceivehardMuteVideo", data: dataDict)
    }
    
    /* This delegate called when a hard unmute video alert participant received from server. */
    func stream(_ stream: EnxStream?, didRecivehardUnmuteVideo data: [Any]?) {
        guard let dataDict = data?[0] as? [String : Any], data!.count>0 else {
            return
        }
        self.emitEvent(event: "stream:didRecivehardUnmuteVideo", data: dataDict)
    }
    
    //Recevie data API
    func didReceiveData(_ data: [AnyHashable : Any]?) {
        if data != nil{
         self.emitEvent(event: "stream:didReceiveData", data: data as Any)
        }
    }
    
    
    
}
