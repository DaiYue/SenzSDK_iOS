//
//  SNZMotionManager.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

@interface SNZSensorManager : NSObject

/// in seconds
@property (nonatomic, assign) CGFloat triggerLoggingInteval;

// sensor

/// in seconds
@property (nonatomic, assign) CGFloat sensorUpdatingInteval;
@property (nonatomic, assign) CGFloat loggingPeriodLength;

- (void)startListening;
- (void)stopListening;

@end
