//
//  SNZUserDataLogger.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZUserDataLogger.h"
#import "SNZSensorManager.h"
#import "SNZLocationManager.h"
#import "SNZBeaconManager.h"
#import "SNZBackgroundTimer.h"
#import "SNZCommonStore.h"

@interface SNZUserDataLogger ()

// logging
@property (nonatomic, assign) BOOL isLogging;
@property (nonatomic, strong) AVQueuePlayer *slientPlayer;
@property (nonatomic, strong) id timeObserver;

// motion
@property (nonatomic, strong) SNZSensorManager* sensorManager;

// location
@property (nonatomic, strong) SNZLocationManager* locationManager;

// beacon
@property (nonatomic, strong) SNZBeaconManager* beaconManager;

@end

@implementation SNZUserDataLogger

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLogging = NO;

        self.sensorManager = [SNZSensorManager new];
        self.locationManager = [SNZLocationManager new];
        //        self.beaconManager = [SNZBeaconManager new];

        [SNZCommonStore sharedInstance].shouldUploadCachedDataWhenWifiAvailable = YES;
    }
    return self;
}

-(void)dealloc {
    [self stopLogging];
}

#pragma mark - Start & Stop

- (BOOL)startLogging {
    [self.locationManager startListening];
    [self.sensorManager startListening];
//    [self.beaconManager startListening];

    return YES;
}

- (void)stopLogging {
    [self.sensorManager stopListening];
    [self.locationManager stopListening];

    [[SNZBackgroundTimer sharedInstance] turnOff];
    self.isLogging = NO;
}

@end
