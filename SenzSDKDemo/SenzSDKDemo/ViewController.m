//
//  ViewController.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/7.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

@property (nonatomic, strong) AVQueuePlayer *player;
@property (nonatomic, strong) id timeObserver;
@property (nonatomic, assign) CGFloat lastTimeStamp;

@property (nonatomic, retain)CMMotionManager * motionManager;

@end

static const CGFloat kTimeInteval = 10;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set AVAudioSession
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];

    // Change the default output audio route
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                            sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);

    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"mp3"]];

    self.player = [[AVQueuePlayer alloc] initWithPlayerItem:playerItem];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;

    // audio
    self.lastTimeStamp = 0.0f;

    // motion
    self.motionManager = [CMMotionManager new];

    // 加速计
    if ([self.motionManager isAccelerometerAvailable]) {
        [self.motionManager startAccelerometerUpdates];
    } else {
        NSLog(@"noAccelerometerAvailable");
    }
    if ([self.motionManager isAccelerometerActive]) {
        NSLog(@"isAccelerometerActive");
    } else {
        NSLog(@"noAccelerometerActive");
    }

    // 陀螺仪
    if ([self.motionManager isGyroAvailable]) {
        [self.motionManager startGyroUpdates];
    } else {
        NSLog(@"noGyroAvailable");
    }
    if ([self.motionManager isGyroActive]) {
        NSLog(@"isGyroActive");
    }else{
        NSLog(@"noGyroActive");
    }

    if ([self.motionManager isDeviceMotionAvailable]) {
        [self.motionManager startDeviceMotionUpdates];
    } else {
        NSLog(@"noGyroAvailable");
    }
    if ([self.motionManager isDeviceMotionActive]) {
        NSLog(@"isGyroActive");
    }else{
        NSLog(@"noGyroActive");
    }

    [self.player addObserver:self
                  forKeyPath:@"currentItem"
                     options:NSKeyValueObservingOptionNew
                     context:nil];

    __weak typeof(self)weakSelf = self;
    void (^observerBlock)(CMTime time) = ^(CMTime time) {
        __typeof(self) strongSelf = weakSelf;

        NSString *timeString = [NSString stringWithFormat:@"%02.2f", (float)time.value / (float)time.timescale];
        CGFloat timeStamp = (float)time.value / (float)time.timescale;
        if (timeStamp - strongSelf.lastTimeStamp < kTimeInteval - 0.001) {
            return;
        }

        strongSelf.lastTimeStamp = timeStamp;
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
            NSLog(@"App is active. Time is: %@", timeString);
        } else {
            NSLog(@"App is backgrounded. Time is: %@", timeString);
        }

        // motion
        CMAccelerometerData *data = strongSelf.motionManager.accelerometerData;

        NSNumber *x  = [NSNumber numberWithDouble:data.acceleration.x];
        NSNumber *y  = [NSNumber numberWithDouble:data.acceleration.y];
        NSNumber *z  = [NSNumber numberWithDouble:data.acceleration.z];
        NSLog(@"acc:x=%@------y=%@--------z=%@",x,y,z);

        [strongSelf.motionManager stopAccelerometerUpdates];

        CMGyroData* gyroData = strongSelf.motionManager.gyroData;
        NSLog(@"gyro:x=%f------y=%f--------z=%f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z);
        
    };

    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(10, 1000)
                                                                  queue:dispatch_get_main_queue()
                                                             usingBlock:observerBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentItem"])
    {
        AVPlayerItem *item = ((AVPlayer *)object).currentItem;
        NSLog(@"New music name: %@", ((AVURLAsset*)item.asset).URL.pathComponents.lastObject);
    }
}

- (IBAction)playOrStop:(id)sender {
    self.startStopButton.selected = !self.startStopButton.selected;
    if (self.startStopButton.selected)
    {
        [self.player play];
    }
    else
    {
        [self.player pause];
    }
}

@end
