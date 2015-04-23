//
//  SNZLocationData.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZLocationData.h"
#import "SNZCommonStore.h"

@implementation SNZCoordinate

+ (instancetype)coordinateWithCLCoordinate:(CLLocationCoordinate2D)coordinate {
    SNZCoordinate* model = [SNZCoordinate new];
    model.latitude = coordinate.latitude;
    model.longitude = coordinate.longitude;
    return model;
}

@end

@implementation SNZLocationData

// TODO: modelWith
+ (instancetype)dataWithLocation:(CLLocation*)location {
    SNZLocationData* model = [SNZLocationData new];
    model.deviceUUID = [SNZCommonStore deviceUUID];
    model.timestamp = [location.timestamp timeIntervalSince1970];

    // TODO:
    model.coordinate = [[SNZCoordinate coordinateWithCLCoordinate:location.coordinate] toJSONString];
    model.altitude = location.altitude;
    model.horizontalAccuracy = location.horizontalAccuracy;
    model.verticalAccuracy = location.verticalAccuracy;
    model.cource = location.course;
    model.speed = location.speed;

    return model;
}

@end
