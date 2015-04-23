//
//  SNZAudioManager.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/7.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZAudioManager.h"

@interface SNZAudioManager ()

// silent background
@property (nonatomic, strong) AVQueuePlayer *slientPlayer;
@property (nonatomic, assign) CGFloat lastRecordTimeStamp;
@property (nonatomic, strong) id timeObserver;

@end

@implementation SNZAudioManager

@end
