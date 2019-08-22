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
   
    @objc func changePlayerScaleType(_ mode: Int, streamId:String?)
    {
      DispatchQueue.main.async {
        guard let player = EnxRN.sharedState.players[streamId!] else {
            return;
        }
        var contentMode = UIView.ContentMode.scaleAspectFit
        if mode == 1{
           contentMode = UIView.ContentMode.scaleAspectFill
        }
        player.contentMode = contentMode
      }
    }
    
    @objc func joinRoom(_ token: String, localInfo: NSDictionary, roomInfo: NSDictionary){
        DispatchQueue.main.async {
            let localStreamInfo : NSDictionary = localInfo
            
            guard let localStreamObject =    self.objectJoin.joinRoom(token, delegate: self, publishStreamInfo: (localStreamInfo as! [AnyHashable : Any]), reconnectInfo: (roomInfo as! [AnyHashable : Any]), advanceOptions: nil) else{
                return
            }
            self.localStream = localStreamObject
            self.localStream.delegate = self as EnxStreamDelegate
        }
    }
    
    
    @objc func publish(){
        
        guard localStream != nil else{
            return
        }
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.publish(localStream)
    }
    
    @objc func initStream(_ streamId:String?){
        guard streamId != nil else{
            return
        }
        DispatchQueue.main.async {
            if(self.localStream != nil) {
                EnxRN.sharedState.publishStreams.updateValue(self.localStream, forKey: (streamId)!)
                guard let player = EnxRN.sharedState.players[streamId!] else{
                    return;
                }
                self.localStream.attachRenderer(player)
            }
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
    
    @objc func subscribe(_ streamId: String?, callback: @escaping RCTResponseSenderBlock) -> Void {
        DispatchQueue.main.async{
            if(streamId == nil || streamId?.count == 0){
                callback(["Error: Invalid streamId to subscribe."])
            }
            guard let stream = EnxRN.sharedState.room?.streamsByStreamId?[streamId!] as? EnxStream else{
                return;
            }
            EnxRN.sharedState.room!.subscribe(stream)
        }
    }
    
    
    @objc func switchCamera(_ streamId: String?){
        
        guard let stream = EnxRN.sharedState.publishStreams[streamId!] else{
            return;
        }
        stream.switchCamera()
    }
    
    @objc func muteSelfAudio(_ streamId: String, value: Bool){
        
        guard let stream = EnxRN.sharedState.publishStreams[streamId] else{
            return;
        }
        stream.muteSelfAudio(value)
        
        
    }
    
    @objc func muteSelfVideo(_ streamId: String?, value: Bool){
        
        guard let stream = EnxRN.sharedState.publishStreams[streamId!] else{
            return;
        }
        stream.muteSelfVideo(value)
    }
    
    
    @objc func startRecord(){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.startRecord()
        
    }
    
    @objc func stopRecord(){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.stopRecord()
        
    }
    
    //Chair Control
    //For Participant
    @objc func requestFloor(){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.requestFloor()
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
    
    @objc func hardMuteAudio(_ streamId: String?, _ clientId: String){
        guard let stream = EnxRN.sharedState.publishStreams[streamId!] else{
            return;
        }
        if clientId.count > 0{
          stream.hardMuteAudio(clientId)
        }
    }
    
    @objc func hardUnmuteAudio(_ streamId: String?, _ clientId: String){
        guard let stream = EnxRN.sharedState.publishStreams[streamId!] else{
            return;
        }
        
        if clientId.count > 0{
            stream.hardUnMuteAudio(clientId)
        }
    }
    
    @objc func hardMuteVideo(_ streamId: String, _ clientId: String){
        guard let stream = EnxRN.sharedState.publishStreams[streamId] else{
            return;
        }
        
        if clientId.count > 0{
            stream.hardMuteVideo(clientId)
        }
    }
    
    @objc func hardUnmuteVideo(_ streamId: String, _ clientId: String) {
        guard let stream = EnxRN.sharedState.publishStreams[streamId] else{
            return;
        }
        if clientId.count > 0{
            stream.hardUnMuteVideo(clientId)
        }
    }
    
    //Hard Room mute
    @objc func hardMute(){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.hardMute()
    }
    
    @objc func hardUnmute(){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.hardUnMute()
    }
    
    @objc func sendData(_ streamId: String, _ data: NSDictionary){
        guard let stream = EnxRN.sharedState.publishStreams[streamId] else{
            return;
        }
            stream.sendData(data as! [AnyHashable : Any])
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
    
    @objc func stopVideoTracksOnApplicationBackground(_ value: Bool, _ videoMuteLocalStream: Bool){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.stopVideoTracks(onApplicationBackground: value)
    }
    
    @objc func startVideoTracksOnApplicationForeground(_ value: Bool, _ videoMuteLocalStream: Bool){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.startVideoTracks(onApplicationForeground: value)
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
    
    //Stats Method
    @objc func enableStats(_ value: Bool){
        guard let room = EnxRN.sharedState.room else {
            return
        }
        room.enableStats(value)
    }
    
//    //Send Message
//    @objc func sendMessage(_ data:NSDictionary, broadCast:Bool, clientIds:NSArray){
//        guard let room = EnxRN.sharedState.room else {
//            return
//        }
//        room.sendMessage(data as! [AnyHashable : Any], broadCast: broadCast, clientIds: clientIds as? [Any])
//    }

    //To enable particular player stream stats.
    @objc func enablePlayerStats(_ value: Bool, _ streamId: String){
        guard let stream = EnxRN.sharedState.publishStreams[streamId] else{
            return;
        }
        guard stream.enxPlayerView != nil else{
            return;
        }
        stream.enxPlayerView?.delegate = self
        stream.enxPlayerView?.enablePlayerStats(value)
    }
    
    @objc func setAdvancedOptions(_ options: NSArray ){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.setAdvanceOptions(options as! [Any])
    }
    
    @objc func getAdvancedOptions(){
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.getAdvanceOptions()
    }
    
    @objc func captureScreenShot(_ streamId: String){
        guard let stream = EnxRN.sharedState.publishStreams[streamId] else{
            return;
        }
        guard stream.enxPlayerView != nil else{
            return;
        }
         DispatchQueue.main.async {
        stream.enxPlayerView?.delegate = self
        stream.enxPlayerView?.captureScreenShot()
        }
    }
    
    @objc func disconnect(){
        
        guard let room = EnxRN.sharedState.room else{
            return
        }
        room.disconnect()
        
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


extension EnxRoomManager : EnxRoomDelegate
{
    func getSupportedEvents() -> [String] {
        
        return ["room:didActiveTalkerList","room:didScreenSharedStarted","room:didScreenShareStopped","room:didCanvasStarted","room:didCanvasStopped","room:didRoomRecordStart","room:didRoomRecordStop","room:didFloorRequested","room:didLogUpload","room:didSetTalkerCount","room:didGetMaxTalkers","room:didGetTalkerCount","room:userDidConnected","room:userDidDisconnected","room:didHardUnMuteAllUser","room:didHardMutedAll","room:didUnMutedAllUser","room:didMutedAllUser","room:didProcessFloorRequested","room:didFloorRequestReceived","room:didReleaseFloorRequested","room:didDenyFloorRequested","room:didGrantFloorRequested","room:didStopRecordingEvent","room:didStartRecordingEvent","room:didSubscribedStream","room:didDisconnected","room:didStreamAdded","room:didEventError","room:didError","room:didPublishedStream","room:didNotifyDeviceUpdate","room:didStatsReceive","room:didAcknowledgeStats","room:didBandWidthUpdated","room:didShareStreamEvent","room:didRoomConnected","room:didReconnect","room:didUserReconnectSuccess","room:didConnectionInterrupted","room:didConnectionLost","room:didCanvasStreamEvent","room:didAdvanceOptionsUpdate","room:didGetAdvanceOptions","room:didCapturedView","stream:didAudioEvent","stream:didVideoEvent","stream:didhardMuteAudio","stream:didhardUnmuteAudio","stream:didRemoteStreamAudioMute","stream:didRemoteStreamAudioUnMute","stream:didRemoteStreamVideoMute","stream:didRecievedHardMutedAudio","stream:didRecievedHardUnmutedAudio","stream:didRemoteStreamVideoUnMute","stream:didHardVideoMute","stream:didHardVideoUnMute","stream:didReceivehardMuteVideo","stream:didRecivehardUnmuteVideo","stream:didReceiveData","stream:didPlayerStats"];
    }
    
    
    func room(_ room: EnxRoom?, didConnect roomMetadata: [AnyHashable : Any]?) {
        EnxRN.sharedState.room = room
        self.emitEvent(event: "room:didRoomConnected", data: roomMetadata as Any)
    }
    
    func room(_ room: EnxRoom?, didError reason: [Any]?) {
        guard let errorVal = reason else{
            return
        }
        self.emitEvent(event: "room:didError", data: errorVal)
    }
    
    func room(_ room: EnxRoom?, didEventError reason: [Any]?) {
        guard let resDict = reason?[0] as? [String : Any], reason!.count > 0 else{
            return
        }
        self.emitEvent(event: "room:didEventError", data:resDict)
    }
    
    func room(_ room: EnxRoom?, didReconnect reason: String?) {
        guard let reasonString = reason else {
            return
        }
        self.emitEvent(event: "room:didReconnect", data:reasonString)
    }
    
    func room(_ room: EnxRoom, didUserReconnectSuccess data: [AnyHashable : Any]) {
        
        self.emitEvent(event: "room:didUserReconnectSuccess", data:data)
    }
    
    func room(_ room: EnxRoom, didConnectionInterrupted data: [Any]) {
        guard let dataDict = data[0] as? [String : Any], data.count > 0 else{
            return
        }
        self.emitEvent(event: "room:didConnectionInterrupted", data:dataDict)
    }
    
    func room(_ room: EnxRoom, didConnectionLost data: [Any]) {
        guard let dataDict = data[0] as? [String : Any], data.count > 0 else{
            return
        }
        self.emitEvent(event: "room:didConnectionLost", data:dataDict)
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
    
    func room(_ room: EnxRoom?, didRemovedStream stream: EnxStream?) {
        guard stream != nil else{
            return
        }
        guard let subscribeStream = EnxRN.sharedState.subscriberStreams[(stream?.streamId)!] else {
            return
        }
        let resultDict : NSDictionary = ["streamId" : subscribeStream.streamId as Any,"msg": "Stream has removed."]
        self.emitEvent(event: "room:didRemoveStream", data: resultDict)
         EnxRN.sharedState.subscriberStreams.removeValue(forKey: subscribeStream.streamId!)

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
        self.emitEvent(event: "room:didActiveTalkerList", data: activeListArray!)
        
        for (_,active) in (activeListArray?.enumerated())! {
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
        guard let shareStream = EnxRN.sharedState.room!.streamsByStreamId![streamId] as? EnxStream else{
            return
        }
        guard let player = EnxRN.sharedState.players[streamId] else{
            return
        }
        shareStream.attachRenderer(player)
        
    }
    
    func room(_ room: EnxRoom?, screenShareStopped Data: [Any]?) {
        guard let shareDict = Data?[0] as? [String : Any], Data!.count > 0 else{
            return
        }
        let streamId = String (shareDict["streamId"] as! Int)
        guard EnxRN.sharedState.players[streamId] != nil else{
            return
        }
        EnxRN.sharedState.players.removeValue(forKey: streamId)
        self.emitEvent(event: "room:didScreenShareStopped", data: shareDict)
    }
    
    //Canvas Delegates
    func room(_ room: EnxRoom?, canvasStarted Data: [Any]?) {
        guard let canvasDict = Data?[0] as? [String : Any], Data!.count > 0 else{
            return
        }
        self.emitEvent(event: "room:didCanvasStarted", data:canvasDict)
        let streamId = String (canvasDict["streamId"] as! Int)
        guard let canvasStream = EnxRN.sharedState.room!.streamsByStreamId![streamId] as? EnxStream else{
            return
        }
        guard let player = EnxRN.sharedState.players[streamId] else{
            return
        }
        canvasStream.attachRenderer(player)
    }
    
    func room(_ room: EnxRoom?, canvasStopped Data: [Any]?) {
        guard let canvasDict = Data?[0] as? [String : Any], Data!.count > 0 else{
            return
        }
        let streamId = String (canvasDict["streamId"] as! Int)
        guard EnxRN.sharedState.players[streamId] != nil else{
            return
        }
        EnxRN.sharedState.players.removeValue(forKey: streamId)
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
    func didhardMute(_ Data: [Any]?) {
    guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didMutedAllUser", data: dataDict)
    }
    
    /* This delegate called when the room is unmuted by the moderator. Available to Moderator only. */
    func didhardUnMute(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didUnMutedAllUser", data: dataDict)
        
    }
    
    /* Participants notified when room is muted by any moderator. */
    func didHardMuteRecived(_ Data: [Any]?) {
        guard let dataDict = Data?[0] as? [String : Any], Data!.count>0 else {
            return
        }
        self.emitEvent(event: "room:didHardMutedAll", data: dataDict)
    }
    
    /*  */
    func didHardunMuteRecived(_ Data: [Any]?) {
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
    
    /**
     This delegate Method Will Notify app user for any Audio media changes happen recentaly(Like :- New device connected/Doisconnected).
     */
    func didNotifyDeviceUpdate(_ updates: String) {
        self.emitEvent(event: "room:didNotifyDeviceUpdate", data: updates)
      
    }
    
    /*
     This method will update once stats enable and update to app user for stats
     @param statsData has all stats information.
     */
    func didStatsReceive(_ statsData: [Any]) {
        self.emitEvent(event: "room:didStatsReceive", data: statsData)
    }
    
    func didAcknowledgeStats(_ subUnSubResponse: [Any]) {
        self.emitEvent(event: "room:didAcknowledgeStats", data: subUnSubResponse)
    }
    
    //ABWD delegates
    func room(_ room: EnxRoom?, didBandWidthUpdated data: [Any]?) {
        guard let Data = data?[0] as? [String : Any] else {
            return
        }
        self.emitEvent(event: "room:didBandWidthUpdated", data: Data)
    }
    
    func room(_ room: EnxRoom?, didCanvasStreamEvent data: [Any]?) {
        guard let Data = data?[0] as? [String : Any] else {
            return
        }
        self.emitEvent(event: "room:didCanvasStreamEvent", data: Data)
    }
    
    func room(_ room: EnxRoom?, didShareStreamEvent data: [Any]?) {
        guard let Data = data?[0] as? [String : Any] else {
            return
        }
        self.emitEvent(event: "room:didShareStreamEvent", data: Data)
    }
    
//    func room(_ room: EnxRoom, didReceiveChatDataAtRoom data: [Any]?) {
//        guard let Data = data?[0] as? [String : Any] else {
//            return
//        }
//        self.emitEvent(event: "room:didReceiveChatDataAtRoom", data: Data)
//    }
//
    
    
    func room(_ room: EnxRoom?, didAdvanceOptionsUpdate data: [AnyHashable : Any]? = nil) {
        self.emitEvent(event: "room:didAdvanceOptionsUpdate", data: data as Any)

    }
    
    func room(_ room: EnxRoom?, didGetAdvanceOptions data: [Any]?) {
        if(data!.count > 0){
            print(data![0])
            self.emitEvent(event: "room:didGetAdvanceOptions", data: data![0] )
            
        }
    }
}

extension EnxRoomManager :  EnxStreamDelegate
{
    /* Stream Delegates */
    
    func didAudioEvents(_ data: [AnyHashable : Any]?) {
        self.emitEvent(event: "stream:didAudioEvent", data: data as Any)
    }
    
    func didVideoEvents(_ data: [AnyHashable : Any]?) {
        self.emitEvent(event: "stream:didVideoEvent", data: data as Any)
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
    
    //Receive data API
    func didReceiveData(_ data: [AnyHashable : Any]?) {
        if data != nil{
            self.emitEvent(event: "stream:didReceiveData", data: data as Any)
        }
    }
  }


extension EnxRoomManager : EnxPlayerDelegate
{
    func didPlayerStats(_ data: [AnyHashable : Any]) {
        self.emitEvent(event: "stream:didPlayerStats", data: data)
    }
    
    func didCapturedView(_ snapShot: UIImage) {
        let imageData:NSData = snapShot.pngData()! as NSData
        let base64String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        self.emitEvent(event: "room:didCapturedView", data: base64String)
    }
}
