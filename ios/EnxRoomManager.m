//
//  EnxRoomManagern.m
//  EnxRtc
//
//  Created by Daljeet Singh on 17/03/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTBridgeMethod.h>
#import <React/RCTEventEmitter.h>
@interface RCT_EXTERN_MODULE(EnxRoomManager, RCTEventEmitter)

RCT_EXTERN_METHOD(initRoom)
RCT_EXTERN_METHOD(connect:(NSString *)token)
RCT_EXTERN_METHOD(joinRoom:(NSString *)token localInfo:(NSDictionary *)localInfo)
RCT_EXTERN_METHOD(publish)
RCT_EXTERN_METHOD(initStream:
                  (NSString*)streamId)
RCT_EXTERN_METHOD(getLocalStreamId:
                  (RCTResponseSenderBlock*)callback)
RCT_EXTERN_METHOD(subscribeToStream:
                  (NSString*)streamId
                  callback:(RCTResponseSenderBlock*)callback)

RCT_EXTERN_METHOD(switchCamera:
                  (NSString*)streamId)
RCT_EXTERN_METHOD(muteSelfAudio:
                  (NSString*)streamId value:(BOOL)value)
RCT_EXTERN_METHOD(muteSelfVideo:
                  (NSString*)streamId value:(BOOL)value)

RCT_EXTERN_METHOD(startRoomRecording)
RCT_EXTERN_METHOD(stopRoomRecording)

RCT_EXTERN_METHOD(disconnect)

RCT_EXTERN_METHOD(setJSComponentEvents:
                  (NSArray*)events)
RCT_EXTERN_METHOD(setNativeEvents:(NSArray*)events)
RCT_EXTERN_METHOD(removeNativeEvents:
                  (NSArray*)events)

//Chair Control
//For Participant
RCT_EXTERN_METHOD(requestFloor)

//For Moderator
RCT_EXTERN_METHOD(grantFloor:
                  (NSString*)clientId)
RCT_EXTERN_METHOD(denyFloor:
                  (NSString*)clientId)
RCT_EXTERN_METHOD(releaseFloor:
                  (NSString*)clientId)


//Hard Mute

//Audio
RCT_EXTERN_METHOD(hardMuteAudio:(NSString*)streamId (NSString*)clientId)
RCT_EXTERN_METHOD(hardUnmuteAudio:(NSString*)streamId (NSString*)clientId)

//Video
RCT_EXTERN_METHOD(hardMuteVideo:(NSString*)streamId (NSString*)clientId)
RCT_EXTERN_METHOD(hardUnmuteVideo:(NSString*)streamId (NSString*)clientId)

// Hard Room mute
RCT_EXTERN_METHOD(muteAllUser)
RCT_EXTERN_METHOD(unMuteAllUser)


//Send Data method
RCT_EXTERN_METHOD (sendData:(NSString *)streamId (NSDictionary *)data)


//Post Client Logs
RCT_EXTERN_METHOD(enableLogs:(BOOL)value)
RCT_EXTERN_METHOD(postClientLogs)

// To enable Stats
RCT_EXTERN_METHOD(enableStats:(BOOL)value)

//Set and get Active Talker
RCT_EXTERN_METHOD(setTalkerCount:(Int)number)
RCT_EXTERN_METHOD(getTalkerCount)
RCT_EXTERN_METHOD(getMaxTalkers)

//changeToAudioOnly
RCT_EXTERN_METHOD(changeToAudioOnly:(BOOL)value)

//To stop video tracks on backgroung and foreground.

RCT_EXTERN_METHOD(muteRemoteStreamInBacground:(BOOL)value)
RCT_EXTERN_METHOD(muteRemoteStreamInForeground:(BOOL)value)


//Audio Device methods
RCT_EXTERN_METHOD(switchMediaDevice:(NSString *)mediaName)
RCT_EXTERN_METHOD(getSelectedDevice:(RCTResponseSenderBlock*)callback)
RCT_EXTERN_METHOD(getDevices:(RCTResponseSenderBlock*)callback)
@end
