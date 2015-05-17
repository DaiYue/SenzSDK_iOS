//
//  SNZMotionManager.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZMotionManager.h"
#import "SNZMotionData.h"
#import "SNZCommonStore.h"
#import "SNZBackgroundModeManager.h"

@interface SNZMotionManager ()

@property (nonatomic, retain) CMMotionManager * motionManager;

@property (nonatomic, assign) CGFloat startListeningTimestamp;
@property (nonatomic, assign) CGFloat listeningPeriodLength;

@end

static const CGFloat kDefaultTriggerLoggingInteval = 15;
static const CGFloat kDefaultSensorLoggingInteval = 0.1;
static const CGFloat kDefaultSensorLoggingPeriodLength = 10;

@implementation SNZMotionManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.motionManager = [CMMotionManager new];

        // init data
        self.triggerLoggingInteval = kDefaultTriggerLoggingInteval;
        self.sensorUpdatingInteval = kDefaultSensorLoggingInteval;
        self.loggingPeriodLength = kDefaultSensorLoggingPeriodLength;

        // accelerometer
        if (![self.motionManager isAccelerometerAvailable]) {
            NSLog(@"noAccelerometerAvailable");
        }

        // gyro
        if (![self.motionManager isGyroAvailable]) {
            NSLog(@"noGyroAvailable");
        }

        //TODO: error handling
    }
    return self;
}

- (void)startListening {
    SNZBackgroundModeManager* backgroundModeManager = [SNZBackgroundModeManager sharedInstance];
    [backgroundModeManager turnOnBackgroundMode];

        __weak typeof(self)weakSelf = self;
    [backgroundModeManager addObserverWithIdentifier:@"SNZMotionManager" forInteval:self.triggerLoggingInteval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (time.value < 0.01) {
            return;
        }

        NSString *timeString = [NSString stringWithFormat:@"%02.2f", (float)time.value / (float)time.timescale];
        NSLog(@"Time is: %@", timeString);
        [weakSelf startListeningFor:weakSelf.loggingPeriodLength inteval:weakSelf.sensorUpdatingInteval];
    }];
}

- (void)startListeningFor:(CGFloat)periodLength inteval:(CGFloat)inteval {

    // data init
    self.startListeningTimestamp = -1;
    self.listeningPeriodLength = periodLength;

    // accelerometer
    self.motionManager.accelerometerUpdateInterval = inteval;

    NSOperationQueue *accQueue = [NSOperationQueue new];
    accQueue.maxConcurrentOperationCount = 1;

    __weak typeof(self)weakSelf = self;
    [self.motionManager startAccelerometerUpdatesToQueue:accQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        if ([weakSelf checkShouldStopListening:accelerometerData.timestamp]) {
            [weakSelf.motionManager stopAccelerometerUpdates];
            return;
        }

        SNZMotionData* model = [SNZMotionData dataWithAccelerometerData:accelerometerData];
        [SNZCommonStore saveDataWithClassName:@"AccelerometerdData" model:model];
    }];

    // gyro
    self.motionManager.gyroUpdateInterval = inteval;

    NSOperationQueue* gyroQueue = [NSOperationQueue new];
    gyroQueue.maxConcurrentOperationCount = 1;

    [self.motionManager startGyroUpdatesToQueue:gyroQueue withHandler:^(CMGyroData *gyroData, NSError *error) {
        if ([weakSelf checkShouldStopListening:gyroData.timestamp]) {
            [weakSelf.motionManager stopGyroUpdates];
            return;
        }

        SNZMotionData* model = [SNZMotionData dataWithGyroData:gyroData];
        [SNZCommonStore saveDataWithClassName:@"Gyro" model:model];
    }];

    //TODO: magnet
}

- (BOOL)checkShouldStopListening:(CGFloat)timeStamp {
    if (self.startListeningTimestamp < 0) {
        self.startListeningTimestamp = timeStamp;
        return NO;
    }

    return timeStamp - self.startListeningTimestamp > self.listeningPeriodLength;
}

- (void)stopListening {
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopGyroUpdates];
}

@end
