//
//  EnxStream.m
//  Enx
//
//  Created by Daljeet Singh on 04/04/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EnxStream.h"
#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(EnxPlayerViewSwift, RCTViewManager)
RCT_EXPORT_VIEW_PROPERTY(streamId, NSString)
@end

