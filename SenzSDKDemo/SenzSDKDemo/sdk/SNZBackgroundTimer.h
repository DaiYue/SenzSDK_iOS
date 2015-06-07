//
//  SNZBackgroundModeManager.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/5/17.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SNZBackgroundTimer : NSObject

+ (SNZBackgroundTimer *)sharedInstance;

/** turn on / off */
- (void)turnOn;
- (void)turnOff;

/** inteval in seconds */
- (void)addTimeObserverWithIdentifier:(NSString*)identifier forInteval:(NSInteger)inteval block:(void (^)(CMTime time))block;

@end
