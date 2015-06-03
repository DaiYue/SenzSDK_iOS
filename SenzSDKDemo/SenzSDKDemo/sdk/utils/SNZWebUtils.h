//
//  SNZWebUtils.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/6/4.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNZReachability;

@interface SNZWebUtils : NSObject

+ (BOOL)isWifiAvailable;

+ (BOOL)isWifiAvailableWithReachablity:(SNZReachability*)reachability;

@end
