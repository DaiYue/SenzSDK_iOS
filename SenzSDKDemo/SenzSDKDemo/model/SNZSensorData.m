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
        self.timestamp = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}

+ (instancetype)dataWithAccelerometerData:(CMAccelerometerData*)data {
    SNZSensorData* model = [SNZSensorData new];
    model.sensorName = @"acc";
    model.values = @[@(data.acceleration.x), @(data.acceleration.y), @(data.acceleration.z)];

    return model;
}

+ (instancetype)dataWithGyroData:(CMGyroData*)data {
    SNZSensorData* model = [SNZSensorData new];
    model.sensorName = @"gyro";
    model.values = @[@(data.rotationRate.x), @(data.rotationRate.y), @(data.rotationRate.z)];

    return model;
}

#pragma mark - NSCoding

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.timestamp = [[aDecoder decodeObjectForKey:@"timestamp"] doubleValue];
        self.sensorName = [aDecoder decodeObjectForKey:@"sensorName"];
        self.values = [aDecoder decodeObjectForKey:@"values"];
    }
    return  self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.timestamp) forKey:@"timestamp"];
    [aCoder encodeObject:self.sensorName forKey:@"sensorName"];
    [aCoder encodeObject:self.values forKey:@"values"];
}

@end

@implementation SNZSensorEvent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.deviceUUID = [SNZCommonStore deviceUUID];
        self.events = (NSMutableArray<SNZSensorData>*)[NSMutableArray array];
    }
    return self;
}

- (void)appendSensorData:(SNZSensorData*)sensorData {
    if (sensorData == nil) {
        return;
    }

    [self.events addObject:sensorData];
}

#pragma mark - NSCoding

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.deviceUUID = [aDecoder decodeObjectForKey:@"deviceUUID"];
        self.events = [aDecoder decodeObjectForKey:@"events"];
    }
    return  self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.deviceUUID forKey:@"deviceUUID"];
    [aCoder encodeObject:self.events forKey:@"events"];
}

@end
