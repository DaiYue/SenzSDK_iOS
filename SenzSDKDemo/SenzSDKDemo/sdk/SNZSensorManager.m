//
//  SNZMotionManager.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZSensorManager.h"
#import "SNZSensorData.h"
#import "SNZCommonStore.h"
#import "SNZBackgroundModeManager.h"
#import "SNZDefs.h"

@interface SNZSensorManager ()

@property (nonatomic, strong) CMMotionManager * motionManager;

@property (atomic, assign) CGFloat startListeningTimestamp;
@property (nonatomic, assign) CGFloat listeningPeriodLength;
@property (atomic, assign) BOOL isSensorOn;

@property (atomic, strong) SNZSensorEvent* sensorEvent;

@end

static const CGFloat kDefaultTriggerLoggingInteval = 15;
static const CGFloat kDefaultSensorLoggingInteval = 0.1;
static const CGFloat kDefaultSensorLoggingPeriodLength = 10;

@implementation SNZSensorManager

#pragma mark - Init & Configure params

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.motionManager = [CMMotionManager new];

        // init data
        self.triggerLoggingInteval = kDefaultTriggerLoggingInteval;
        self.sensorUpdatingInteval = kDefaultSensorLoggingInteval;
        self.loggingPeriodLength = kDefaultSensorLoggingPeriodLength;

        // error handling
        if (![self.motionManager isAccelerometerAvailable] && ![self.motionManager isGyroAvailable]) {
            // no sensor available
            return nil;
        }
    }
    return self;
}

- (void)setSensorUpdatingInteval:(CGFloat)sensorUpdatingInteval {
    _sensorUpdatingInteval = sensorUpdatingInteval;

    self.motionManager.accelerometerUpdateInterval = sensorUpdatingInteval;
    self.motionManager.gyroUpdateInterval = sensorUpdatingInteval;
}

#pragma - Start & Stop listening

- (void)startListening {
    SNZBackgroundModeManager* backgroundModeManager = [SNZBackgroundModeManager sharedInstance];
    [backgroundModeManager turnOnBackgroundMode];

    __weak typeof(self)weakSelf = self;
    [backgroundModeManager addObserverWithIdentifier:@"SNZSensorManager" forInteval:self.triggerLoggingInteval usingBlock:^(CMTime time) {
        if (time.value < 0.01) {
            return;
        }

        [weakSelf turnOnSensorFor:weakSelf.loggingPeriodLength]; // in seconds
    }];
}

- (void)stopListening {
    [self turnOffSensor];
}

#pragma - Handling Sensor

- (void)turnOnSensorFor:(CGFloat)periodLength {

    // data init
    self.startListeningTimestamp = [[NSDate date] timeIntervalSince1970];
    self.listeningPeriodLength = periodLength; // in seconds
    self.isSensorOn = YES;
    self.sensorEvent = [SNZSensorEvent new];

    // accelerometer
    __weak typeof(self)weakSelf = self;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [weakSelf sensorCallbackWithData:[SNZSensorData dataWithAccelerometerData:accelerometerData]];
    }];

    // gyro
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMGyroData *gyroData, NSError *error) {
        [weakSelf sensorCallbackWithData:[SNZSensorData dataWithGyroData:gyroData]];
    }];
}

- (void)sensorCallbackWithData:(SNZSensorData*)data {
    @synchronized(self.sensorEvent) {
        if (self.isSensorOn == NO || data == nil) {
            return; // discard late data
        }

        [self.sensorEvent appendSensorData:data];
    }

    if ([self shouldTurnOffSensor:data.timestamp]) {
        [self turnOffSensor];
        return;
    }
}

- (BOOL)shouldTurnOffSensor:(CGFloat)timeStamp {
    return timeStamp - self.startListeningTimestamp > self.listeningPeriodLength; // in microseconds
}

- (void)turnOffSensor {
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopGyroUpdates];

    @synchronized(self.sensorEvent) {
        self.isSensorOn = NO;

        [SNZCommonStore saveDataEventuallyWithClassName:kSNZAVClassNameSensor model:self.sensorEvent];
        self.sensorEvent = nil;
    }
}

@end
