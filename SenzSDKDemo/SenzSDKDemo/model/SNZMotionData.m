//
//  SNZAccelerometerData.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZMotionData.h"
#import <CoreMotion/CoreMotion.h>
#import "SNZCommonStore.h"

@implementation SNZMotionData

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (instancetype)dataWithAccelerometerData:(CMAccelerometerData*)data {
    SNZMotionData* model = [SNZMotionData new];
    model.deviceUUID = [SNZCommonStore deviceUUID];
    model.timestamp = [[NSDate date] timeIntervalSince1970];
    model.x = data.acceleration.x;
    model.y = data.acceleration.y;
    model.z = data.acceleration.z;

    return model;
}

+ (instancetype)dataWithGyroData:(CMGyroData*)data {
    SNZMotionData* model = [SNZMotionData new];
    model.deviceUUID = [SNZCommonStore deviceUUID];
    model.timestamp = [[NSDate date] timeIntervalSince1970];
    model.x = data.rotationRate.x;
    model.y = data.rotationRate.y;
    model.z = data.rotationRate.z;
    
    return model;
}

@end
