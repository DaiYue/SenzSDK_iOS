//
//  SNZUserDataLogger.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZUserDataLogger.h"
#import "SNZMotionManager.h"
#import "SNZLocationManager.h"
#import "SNZBeaconManager.h"

@interface SNZUserDataLogger ()

// logging
@property (nonatomic, assign) BOOL isLogging;
@property (nonatomic, strong) AVQueuePlayer *slientPlayer;
@property (nonatomic, strong) id timeObserver;

// motion
@property (nonatomic, strong) SNZMotionManager* motionManager;

// location
@property (nonatomic, strong) SNZLocationManager* locationManager;

// beacon
@property (nonatomic, strong) SNZBeaconManager* beaconManager;

@end

static NSString* const kSilentMusicFileName = @"sample";
static const CGFloat kDefaultTriggerLoggingInteval = 15;
static const CGFloat kDefaultSensorLoggingInteval = 0.1;
static const CGFloat kDefaultSensorLoggingPeriodLength = 10;

@implementation SNZUserDataLogger

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLogging = NO;

        self.triggerLoggingInteval = kDefaultTriggerLoggingInteval;
        self.sensorLoggingInteval = kDefaultSensorLoggingInteval;
        self.sensorLoggingPeriodLength = kDefaultSensorLoggingPeriodLength;

        self.motionManager = [SNZMotionManager new];
        self.locationManager = [SNZLocationManager new];
//        self.beaconManager = [SNZBeaconManager new];
    }
    return self;
}

-(void)dealloc {
    [self stopLogging];
}

#pragma mark - Start & Stop

- (BOOL)startLogging {
    [self.beaconManager startListening];

    // configure AVAudioSession
    NSError *sessionError = nil;
    AVAudioSession* session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions: AVAudioSessionCategoryOptionDefaultToSpeaker error:&sessionError];
    if (sessionError != nil) {
        return NO;
    }

    // init player
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:kSilentMusicFileName withExtension:@"mp3"]];
    self.slientPlayer = [AVQueuePlayer queuePlayerWithItems:@[playerItem]];
    self.slientPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.slientPlayer currentItem]];

    // init observer
    __weak typeof(self)weakSelf = self;
    self.timeObserver = [self.slientPlayer addPeriodicTimeObserverForInterval:CMTimeMake(self.triggerLoggingInteval * 1000, 1000)
                            queue:dispatch_get_main_queue()
                            usingBlock:^(CMTime time){
                                if (time.value < 0.01) {
                                    return;
                                }

                                __typeof(self) strongSelf = weakSelf;
                                NSString *timeString = [NSString stringWithFormat:@"%02.2f", (float)time.value / (float)time.timescale];
                                NSLog(@"Time is: %@", timeString);

                                [strongSelf.locationManager fetchLocation];
//                                [strongSelf.motionManager startListeningFor:strongSelf.sensorLoggingPeriodLength inteval:strongSelf.sensorLoggingInteval];
                            }];

    [self.slientPlayer play];

    self.isLogging = YES;

    return YES;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem* playerItem = [notification object];
    [playerItem seekToTime:kCMTimeZero];
}

- (void)stopLogging {
    [self.motionManager stopListening];

    [self.slientPlayer pause];
    self.isLogging = NO;
}

//
//- (BOOL)startLoggingMotionData {
//    if (![self startLogging]) {
//        return NO;
//    }
//}
//
//- (BOOL)startLoggingLocation {
//    if (![self startLogging]) {
//        return NO;
//    }
//}
//
//- (BOOL)startLoggingBeaconNearby {
//    if (![self startLogging]) {
//        return NO;
//    }
//}
//
//- (BOOL)startLoggingEnvironmentSound {
//    //TODO: to be implemented if possible
//    if (![self startLogging]) {
//        return NO;
//    }
//    return YES;
//}


@end
