//
//  SNZNetworkUtils.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/6/7.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SNZNetworkStatusChangedBlock)(BOOL isAvailable);

@interface SNZNetworkObserver : NSObject

/// Singleton initializer
+ (SNZNetworkObserver *)sharedInstance;

- (void)startObservingWifiStatusWithChangedBlock:(SNZNetworkStatusChangedBlock)block;
- (void)stopObservingWifiStatusChange;

- (BOOL)isWifiAvailable;

@end
