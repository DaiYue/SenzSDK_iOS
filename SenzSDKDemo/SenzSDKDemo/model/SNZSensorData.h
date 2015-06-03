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

/// 包含单个sensor单次数据
@interface SNZSensorData : JSONModel

@property (nonatomic, assign) CGFloat timestamp;

@property (nonatomic, strong) NSString* sensorName;
@property (nonatomic, strong) NSArray* values;

+ (instancetype)dataWithAccelerometerData:(CMAccelerometerData*)data;
+ (instancetype)dataWithGyroData:(CMGyroData*)data;

@end

/// 包含一系列 SNZSensorData
@interface SNZSensorEvent : JSONModel

@property (nonatomic, strong) NSString* deviceUUID;

@property (nonatomic, strong) NSMutableArray* events;

- (void)appendSensorData:(SNZSensorData*)sensorData;

@end
