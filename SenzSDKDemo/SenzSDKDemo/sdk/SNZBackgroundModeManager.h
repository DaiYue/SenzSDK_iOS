//
//  SNZBackgroundModeManager.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/5/17.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SNZBackgroundModeManager : NSObject

+ (SNZBackgroundModeManager *)sharedInstance;

/** turn on / off */
- (void)turnOnBackgroundMode;
- (void)turnOffBackgroundMode;

/** inteval in seconds */
- (void)addObserverWithIdentifier:(NSString*)identifier forInteval:(NSInteger)inteval queue:(dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block;

@end
