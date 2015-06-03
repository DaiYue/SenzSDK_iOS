//
//  SNZAccelerometerData.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZSensorData.h"
#import <CoreMotion/CoreMotion.h>
#import "SNZCommonStore.h"

@implementation SNZSensorData

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (instancetype)dataWithAccelerometerData:(CMAccelerometerData*)data {
    SNZSensorData* model = [SNZSensorData new];
    model.timestamp = [[NSDate date] timeIntervalSince1970];
    model.sensorName = @"acc";
    model.values = @[@(data.acceleration.x), @(data.acceleration.y), @(data.acceleration.z)];

    return model;
}

+ (instancetype)dataWithGyroData:(CMGyroData*)data {
    SNZSensorData* model = [SNZSensorData new];
    model.timestamp = [[NSDate date] timeIntervalSince1970];
    model.sensorName = @"gyro";
    model.values = @[@(data.rotationRate.x), @(data.rotationRate.y), @(data.rotationRate.z)];

    return model;
}

@end

@implementation SNZSensorEvent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.events = [NSMutableArray array];
    }
    return self;
}

- (void)appendSensorData:(SNZSensorData*)sensorData {
    if (sensorData == nil) {
        return;
    }

    [self.events addObject:sensorData];
}

@end
