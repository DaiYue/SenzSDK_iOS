//
//  SNZMotionManager.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

@interface SNZMotionManager : NSObject

- (void)startListeningFor:(CGFloat)periodLength inteval:(CGFloat)inteval;
- (void)stopListening;

@end
