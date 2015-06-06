//
//  SNZCommonStore.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZCommonStore.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SNZModel.h"
#import "SNZWebUtils.h"
#import "SNZReachability.h"

@interface SNZCommonStore ()

@property (nonatomic, strong) SNZReachability* reachability;

@end

@implementation SNZCommonStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        SNZReachability *reachability = [SNZReachability reachabilityForLocalWiFi];
        [reachability startNotifier];
        self.reachability = reachability;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifiReachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [self.reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark - DB Cache

- (void)wifiReachabilityDidChange:(NSNotification *)notification {
    SNZReachability *reachability = (SNZReachability *)[notification object];

    if ([SNZWebUtils isWifiAvailableWithReachablity:reachability]) {
        // check db cache: if not empty, start uploading cached data
    }
}

#pragma mark - Common Data

+ (NSString*)deviceUUID {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* deviceUUID = [userDefaults objectForKey:@"deviceUUID"];
    if (deviceUUID == nil) {
        deviceUUID = [[NSUUID UUID] UUIDString];
        [userDefaults setObject:deviceUUID forKey:@"deviceUUID"];
    }

    return deviceUUID;
}

#pragma mark - DB or LeanCloud

+ (void)saveDataEventuallyWithClassName:(NSString *)className model:(SNZModel *)model {
    if (model == nil) {
        return;
    }

    if ([SNZWebUtils isWifiAvailable]) {
        [self uploadDataWithClassName:className model:model];
    } else {
        // cache in db
    }
}

#pragma mark - LeanCloud

+ (void)uploadDataWithClassName:(NSString*)className dictionary:(NSDictionary*)dictionary {
    if (dictionary == nil) {
        return;
    }

    AVObject* object = [AVObject objectWithClassName:className dictionary:dictionary];
    [object saveInBackground];
}

+ (void)uploadDataWithClassName:(NSString*)className model:(SNZModel*)model {
    AVObject* object = [model avObject];
    [object saveInBackground];
}

@end
