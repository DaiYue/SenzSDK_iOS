//
//  SNZLocationData.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSONModel.h"
#import <CoreLocation/CoreLocation.h>

@interface SNZCoordinate : JSONModel

@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

+ (instancetype)coordinateWithCLCoordinate:(CLLocationCoordinate2D)coordinate;

@end

@interface SNZLocationData : JSONModel

@property (nonatomic, strong) NSString* deviceUUID;
@property (nonatomic, assign) CGFloat timestamp;

@property (nonatomic, assign) NSString* coordinate;
@property (nonatomic, assign) CGFloat altitude;
@property (nonatomic, assign) CGFloat horizontalAccuracy;
@property (nonatomic, assign) CGFloat verticalAccuracy;
@property (nonatomic, assign) CGFloat cource;
@property (nonatomic, assign) CGFloat speed;

+ (instancetype)dataWithLocation:(CLLocation*)location;

@end
