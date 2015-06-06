//
//  SNZModel.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/6/6.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZModel.h"

static NSString* const kSNZAVClassNameDevice = @"Device";

static NSString* const kSNZAVClassNameLocation = @"UserLocation";

static NSString* const kSNZAVClassNameSensor = @"UserSensor";

static NSString* const kSNZAVClassNameUnKnown = @"UnKnown";

static NSDictionary* kAVClassNameDictionary;

@implementation SNZModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            kAVClassNameDictionary = @{
                             @"SNZSensorEvent": kSNZAVClassNameSensor,
                             @"SNZLocationData": kSNZAVClassNameLocation
                             };
        });

    }
    return self;
}

- (AVObject*)avObject {
    NSDictionary* dictionary = [self toDictionary];
    return [AVObject objectWithClassName:[self avClassName] dictionary:dictionary];
}

- (NSString*)avClassName {
    NSString* className = NSStringFromClass(self.class);
    if (className == nil) {
        return kSNZAVClassNameUnKnown;
    }

    NSString* avClassName = kAVClassNameDictionary[className];
    if (avClassName == nil) {
        return kSNZAVClassNameUnKnown;
    }
    return avClassName;
}

@end
