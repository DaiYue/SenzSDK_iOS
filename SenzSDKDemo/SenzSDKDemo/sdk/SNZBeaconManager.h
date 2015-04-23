//
//  SNZBeaconManager.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SNZBeaconManager : NSObject<CLLocationManagerDelegate>

@property NSArray* beaconUUIDArray;

- (void)startListening;
- (void)stopListening;

@end
