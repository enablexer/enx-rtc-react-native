
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import <EnxRTCiOS/EnxRTCiOS.h>


@interface EnxManager : NSObject <RCTBridgeModule>
@property(nonatomic,strong) EnxStream *steam;



@end
  
