//
//  SNZUserDataLogger.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

@interface SNZUserDataLogger : NSObject<AVAudioSessionDelegate>

- (BOOL)startLogging;
- (void)stopLogging;
//
//- (BOOL)startLoggingSensorData;
//- (BOOL)startLoggingLocation;
//- (BOOL)startLoggingBeaconNearby;

@end
