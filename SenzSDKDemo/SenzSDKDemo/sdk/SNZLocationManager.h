//
//  SNZLocationManager.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/7.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SNZLocationManager : NSObject<CLLocationManagerDelegate>

- (void)startListening;
- (void)stopListening;
- (void)boostUpdating;

@end
