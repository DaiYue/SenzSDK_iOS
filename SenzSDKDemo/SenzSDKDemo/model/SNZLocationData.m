//
//  SNZLocationData.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZLocationData.h"
#import <AVOSCloud/AVOSCloud.h>

#import "SNZCommonStore.h"

@implementation SNZLocationData

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (instancetype)dataWithLocation:(CLLocation*)location {
    SNZLocationData* model = [SNZLocationData new];

    model.deviceUUID = [SNZCommonStore deviceUUID];
    model.timestamp = [location.timestamp timeIntervalSince1970];
    model.location = location;
    model.type = @"Earth";

    return model;
}

// override this method because of the geo point.
- (AVObject*)avObject {
    AVObject* object = [AVObject objectWithClassName:[self avClassName]];

    // basic info
    [object setObject:self.deviceUUID forKey:@"deviceUUID"];
    [object setObject:@(self.timestamp) forKey:@"timestamp"];

    // location
    [object setObject:self.type forKey:@"type"];
    [object setObject:[AVGeoPoint geoPointWithLocation:self.location] forKey:@"location"];
    [object setObject:@(self.location.altitude) forKey:@"altitude"];
    [object setObject:@(self.location.horizontalAccuracy) forKey:@"horizontalAccuracy"];
    [object setObject:@(self.location.verticalAccuracy) forKey:@"verticalAccuracy"];

    return object;
}

#pragma mark - NSCoding

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.deviceUUID = [aDecoder decodeObjectForKey:@"deviceUUID"];
        self.timestamp = [[aDecoder decodeObjectForKey:@"timestamp"] doubleValue];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.deviceUUID forKey:@"deviceUUID"];
    [aCoder encodeObject:@(self.timestamp) forKey:@"timestamp"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.type forKey:@"type"];
}

@end
