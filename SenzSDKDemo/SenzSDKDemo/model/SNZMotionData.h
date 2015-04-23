//
//  SNZAccelerometerData.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSONModel.h"

@class CMAccelerometerData;
@class CMGyroData;

@interface SNZMotionData : JSONModel

@property (nonatomic, strong) NSString* deviceUUID;
@property (nonatomic, assign) CGFloat timestamp;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat z;

+ (instancetype)dataWithAccelerometerData:(CMAccelerometerData*)data;
+ (instancetype)dataWithGyroData:(CMGyroData*)data;

@end
