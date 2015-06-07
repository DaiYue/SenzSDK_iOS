//
//  SNZCommonStore.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@class SNZModel;

@interface SNZCommonStore : NSObject

@property (nonatomic, assign) BOOL shouldUploadCachedDataWhenWifiAvailable;

+ (SNZCommonStore *)sharedInstance;

// == Common Data ==
+ (NSString*)deviceUUID;

// == Cache or Upload ==
+ (void)saveDataEventuallyWithModel:(SNZModel*)model;

// == Upload ==
+ (void)uploadDataWithClassName:(NSString*)className dictionary:(NSDictionary*)dictionary;
+ (void)uploadDataWithModel:(SNZModel*)model block:(AVBooleanResultBlock)block;

@end
