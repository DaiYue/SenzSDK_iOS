//
//  SNZWebUtils.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/6/4.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZWebUtils.h"
#import "SNZReachability.h"

@implementation SNZWebUtils

+ (BOOL)isWifiAvailable {
    return [self isWifiAvailableWithReachablity:[SNZReachability reachabilityForLocalWiFi]];
}

+ (BOOL)isWifiAvailableWithReachablity:(SNZReachability*)reachability {
    return reachability.currentReachabilityStatus == ReachableViaWiFi;
}

@end
