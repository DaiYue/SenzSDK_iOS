//
//  SNZNetworkUtils.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/6/7.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZNetworkObserver.h"
#import "SNZReachability.h"

@interface SNZNetworkObserver ()

@property (nonatomic, strong) SNZReachability* reachability;

@property (nonatomic, copy) SNZNetworkStatusChangedBlock wifiStatusChangeBlock;

@end

@implementation SNZNetworkObserver

+ (SNZNetworkObserver *)sharedInstance {
    static SNZNetworkObserver *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^(void) {
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        SNZReachability *reachability = [SNZReachability reachabilityForLocalWiFi];
        [reachability startNotifier];
        self.reachability = reachability;
    }
    return self;
}

- (void)dealloc {
    [self.reachability stopNotifier];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Wifi Status

- (void)startObservingWifiStatusWithChangedBlock:(SNZNetworkStatusChangedBlock)block {
    self.wifiStatusChangeBlock = block;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifiReachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
}

- (void)stopObservingWifiStatusChange {
    self.wifiStatusChangeBlock = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)wifiReachabilityDidChange:(NSNotification *)notification {
    if (self.wifiStatusChangeBlock != nil) {
        self.wifiStatusChangeBlock([self isWifiAvailable]);
    }
}

- (BOOL)isWifiAvailable {
    return self.reachability.currentReachabilityStatus == ReachableViaWiFi;
}

@end
