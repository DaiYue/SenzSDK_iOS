//
//  SNZLocationData.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "SNZModel.h"

@interface SNZLocationData : SNZModel

@property (nonatomic, strong) NSString* deviceUUID;
@property (nonatomic, assign) CGFloat timestamp;
@property (nonatomic, strong) NSString* type;

@property (nonatomic, strong) CLLocation* location;

+ (instancetype)dataWithLocation:(CLLocation*)location;

@end
