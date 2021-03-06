//
//  SNZBackgroundModeManager.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/5/17.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZBackgroundTimer.h"
#import <UIKit/UIKit.h>
#import "NSMutableDictionary+SNZUtility.h"

@interface SNZBackgroundTimer ()

@property (nonatomic, assign) BOOL isBackgroundModeOn;
@property (nonatomic, strong) AVQueuePlayer *slientPlayer;
@property (nonatomic, strong) id timeObserver;

@property (nonatomic, strong) NSMutableDictionary* observerDictionary;

@end

static NSString* const kSilentMusicFileName = @"sample";

@implementation SNZBackgroundTimer

+(SNZBackgroundTimer *)sharedInstance
{
    static SNZBackgroundTimer *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^(void) {
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isBackgroundModeOn = NO;
    }
    return self;
}

#pragma mark - Turn On / Off

- (void)turnOn {
    if (self.isBackgroundModeOn == YES) {
        return; // already on
    }

    // player
    [self configureAudioSession];

    self.slientPlayer = [self setupPlayerWithFileName:kSilentMusicFileName];
    [self.slientPlayer play];

    // observer
    self.observerDictionary = [NSMutableDictionary dictionary];

    self.isBackgroundModeOn = YES;
}

- (void)turnOff {
    if (self.isBackgroundModeOn == NO) {
        return; // already off
    }

    // player
    [self.slientPlayer pause];
    self.slientPlayer = nil;

    // observer
    self.observerDictionary = [NSMutableDictionary dictionary]; // release the observers

    self.isBackgroundModeOn = NO;
}

#pragma mark - Audio

- (void)configureAudioSession {
    NSError *sessionError = nil;
    AVAudioSession* session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback withOptions: AVAudioSessionCategoryOptionMixWithOthers error:&sessionError];
    if (sessionError != nil) {
        //TODO: error: session error
        return;
    }
}

- (AVQueuePlayer*)setupPlayerWithFileName:(NSString*)fileName {
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:fileName withExtension:@"mp3"]];
    AVQueuePlayer* player = [AVQueuePlayer queuePlayerWithItems:@[playerItem]];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    // loop
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(playerItemDidReachEnd:)
        name:AVPlayerItemDidPlayToEndTimeNotification
        object:[player currentItem]];

    return player;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem* playerItem = [notification object];
    [playerItem seekToTime:kCMTimeZero];
}

#pragma mark - Observers

- (void)addTimeObserverWithIdentifier:(NSString*)identifier forInteval:(NSInteger)inteval block:(void (^)(CMTime time))block {
    if (identifier.length == 0) {
        return;
    }

    id timeObserver = [self.slientPlayer addPeriodicTimeObserverForInterval:CMTimeMake(inteval * 1000, 1000)
                            queue:dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
                            usingBlock:^(CMTime time) {
                                if (time.value < 0.01) {
                                    return;
                                }

                                if (block != nil) {
                                    block(time);
                                }
                            }];
    [self.observerDictionary setObjectSafe:timeObserver forKey:identifier];
}

@end
