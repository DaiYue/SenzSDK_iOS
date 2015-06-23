//
//  SNZCommonStore.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZCommonStore.h"
#import "SNZModel.h"
#import "SNZNetworkObserver.h"
#import "SNZReachability.h"
#import "TMCache.h"

@interface SNZCommonStore ()

@property (atomic, assign) BOOL isUploadingCachedData;

@end

@implementation SNZCommonStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isUploadingCachedData = NO;
    }
    return self;
}

+ (SNZCommonStore *)sharedInstance {
    static SNZCommonStore *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^(void) {
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
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

#pragma mark - Upload or Cache

+ (void)saveDataEventuallyWithModel:(SNZModel *)model {
    if (model == nil) {
        return;
    }

    if ([[SNZNetworkObserver sharedInstance] isWifiAvailable]) {
        [self uploadDataWithModel:model block:^(BOOL succeeded, NSError *error){
            if (succeeded == NO) {
                [self cacheModel:model];
            }
        }];

        [[SNZCommonStore sharedInstance] startUploadingCachedData];
    } else {
        [self cacheModel:model];
    }
}

#pragma mark - Upload

+ (void)uploadDataWithClassName:(NSString*)className dictionary:(NSDictionary*)dictionary {
    if (dictionary == nil) {
        return;
    }

    AVObject* object = [AVObject objectWithClassName:className dictionary:dictionary];
    [object saveInBackground];
}

+ (void)uploadDataWithModel:(SNZModel*)model block:(AVBooleanResultBlock)block {
    AVObject* object = [model avObject];
    [object saveInBackgroundWithBlock:block];
}

+ (BOOL)uploadDataWithModel:(SNZModel*)model error:(NSError **)error {
    AVObject* object = [model avObject];
    return [object save:error];
}

#pragma mark - Upload Cache

- (void)setShouldUploadCachedDataWhenWifiAvailable:(BOOL)shouldUpload {
    _shouldUploadCachedDataWhenWifiAvailable = shouldUpload;

    if (shouldUpload) {
        [self uploadCachedDataWhenWifiAvailable];
    } else {
        [self neverUploadCachedData];
        [self stopUploadingCachedData];
    }
}

- (void)uploadCachedDataWhenWifiAvailable {
    __weak typeof(self)weakSelf = self;

    SNZNetworkObserver* networkObserver = [SNZNetworkObserver sharedInstance];
    if ([networkObserver isWifiAvailable]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf startUploadingCachedData];
        });
    }

    [networkObserver startObservingWifiStatusWithChangedBlock:^(BOOL isAvailable) {
        if (isAvailable == NO) {
            [weakSelf stopUploadingCachedData];
        }
    }];
}

- (void)neverUploadCachedData {
    [[SNZNetworkObserver sharedInstance] stopObservingWifiStatusChange];
}

- (void)startUploadingCachedData {
    AVObject* object = [AVObject objectWithClassName:@"SNZLog"];
    [object setObject:@"Start uploading!" forKey:@"info"];
    [object saveEventually];

    if (self.isUploadingCachedData == YES) {
        // already uploading
        return;
    }

    self.isUploadingCachedData = YES;

    TMDiskCache* diskCache = [TMDiskCache sharedCache];

    // collect all the keys
    NSMutableArray* keyArray = [NSMutableArray array];
    [diskCache enumerateObjectsWithBlock:^(TMDiskCache *cache, NSString *key, id<NSCoding> object, NSURL *fileURL) {
        if ([key hasPrefix:@"SNZ"]) {
            [keyArray addObject:key];
        }
    }];

    // upload each record according to the keys
    for (NSString* key in keyArray) {
        if (self.isUploadingCachedData == NO) {
            break; // had forced to stop
        }

        SNZModel* model = (SNZModel*)[diskCache objectForKey:key];

        NSError* error = nil;
        if ([SNZCommonStore uploadDataWithModel:model error:&error]) {
            [diskCache removeObjectForKey:key block:nil];
        } else {
            AVObject* object = [AVObject objectWithClassName:@"SNZLog"];
            [object setObject:error.userInfo forKey:@"errorUserInfo"];
            [object setObject:error.localizedDescription forKey:@"errorDescription"];
            [object saveEventually];
            break; // error occured. stop uploading
        }
    }

    object = [AVObject objectWithClassName:@"SNZLog"];
    [object setObject:@"Uploading ended!" forKey:@"info"];
    [object saveEventually];

    self.isUploadingCachedData = NO;
}

- (void)stopUploadingCachedData {
    self.isUploadingCachedData = NO;
}

#pragma mark - Cache

+ (void)cacheModel:(SNZModel*)model {
    if (model == nil) {
        return;
    }

    TMDiskCache* diskCache = [TMDiskCache sharedCache];
    diskCache.byteLimit = 5 * 1024 * 1024;
    [diskCache setObject:model forKey:[self cacheKey]];
}

+ (NSString*)cacheKey {
    return [NSString stringWithFormat:@"SNZ%@", [[NSUUID UUID] UUIDString]];
}

@end
