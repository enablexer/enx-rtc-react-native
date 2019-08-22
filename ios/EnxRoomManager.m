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
RCT_EXTERN_METHOD(joinRoom:(NSString *)token localInfo:(NSDictionary *)localInfo roomInfo:(NSDictionary *)roomInfo)
RCT_EXTERN_METHOD(publish)
RCT_EXTERN_METHOD(initStream:
                  (NSString*)streamId)
RCT_EXTERN_METHOD(getLocalStreamId:
                  (RCTResponseSenderBlock*)callback)
RCT_EXTERN_METHOD(subscribe:
                  (NSString*)streamId
                  callback:(RCTResponseSenderBlock*)callback)

RCT_EXTERN_METHOD(switchCamera:
                  (NSString*)streamId)
RCT_EXTERN_METHOD(muteSelfAudio:
                  (NSString*)streamId value:(BOOL)value)
RCT_EXTERN_METHOD(muteSelfVideo:
                  (NSString*)streamId value:(BOOL)value)

RCT_EXTERN_METHOD(startRecord)
RCT_EXTERN_METHOD(stopRecord)

RCT_EXTERN_METHOD(disconnect)

RCT_EXTERN_METHOD(setJSComponentEvents:
                  (NSArray*)events)
RCT_EXTERN_METHOD(removeJSComponentEvents:
                  (NSArray*)events)
RCT_EXTERN_METHOD(setNativeEvents:(NSArray*)events)
RCT_EXTERN_METHOD(removeNativeEvents:
                  (NSArray*)events)
RCT_EXTERN_METHOD(changePlayerScaleType:
                  (int)mode streamId:(NSString*)streamId)
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
RCT_EXTERN_METHOD(hardMuteAudio:(NSString*)streamId clientId:(NSString*)clientId)
RCT_EXTERN_METHOD(hardUnmuteAudio:(NSString*)streamId clientId:(NSString*)clientId)

//Video
RCT_EXTERN_METHOD(hardMuteVideo:(NSString*)streamId clientId:(NSString*)clientId)
RCT_EXTERN_METHOD(hardUnmuteVideo:(NSString*)streamId clientId:(NSString*)clientId)

// Hard Room mute
RCT_EXTERN_METHOD(hardMute)
RCT_EXTERN_METHOD(hardUnmute)


//Send Data method
RCT_EXTERN_METHOD (sendData:(NSString *)streamId data:(NSDictionary *)data)


//Post Client Logs
RCT_EXTERN_METHOD(enableLogs:(BOOL)value)
RCT_EXTERN_METHOD(postClientLogs)

//Set and get Active Talker
RCT_EXTERN_METHOD(setTalkerCount:(Int)number)
RCT_EXTERN_METHOD(getTalkerCount)
RCT_EXTERN_METHOD(getMaxTalkers)

//changeToAudioOnly
RCT_EXTERN_METHOD(changeToAudioOnly:(BOOL)value)

//To stop video tracks on backgroung and foreground.

RCT_EXTERN_METHOD(stopVideoTracksOnApplicationBackground:(BOOL)value (BOOL)videoMutelocalStream)
RCT_EXTERN_METHOD(startVideoTracksOnApplicationForeground:(BOOL)value (BOOL)videoMutelocalStream)


//Audio Device methods
RCT_EXTERN_METHOD(switchMediaDevice:(NSString *)mediaName)
RCT_EXTERN_METHOD(getSelectedDevice:(RCTResponseSenderBlock*)callback)
RCT_EXTERN_METHOD(getDevices:(RCTResponseSenderBlock*)callback)

//Stats Methods
RCT_EXTERN_METHOD(enablePlayerStats:(BOOL)value streamId:(NSString *)streamId)
RCT_EXTERN_METHOD(enableStats:(BOOL)value)



//Set Advance Options
RCT_EXTERN_METHOD(setAdvancedOptions:(NSArray *)options)

RCT_EXTERN_METHOD(getAdvancedOptions)

// To capture player view screen shot
RCT_EXTERN_METHOD(captureScreenShot:(NSString *)streamId)

@end
