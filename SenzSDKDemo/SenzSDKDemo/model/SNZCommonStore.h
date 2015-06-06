//
//  SNZCommonStore.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNZModel;

@interface SNZCommonStore : NSObject

// == Common Data ==
+ (NSString*)deviceUUID;

// == DB or LeanCloud ==
+ (void)saveDataEventuallyWithClassName:(NSString*)className model:(SNZModel*)model;

// == LeanCloud ==
+ (void)uploadDataWithClassName:(NSString*)className dictionary:(NSDictionary*)dictionary;
+ (void)uploadDataWithClassName:(NSString*)className model:(SNZModel*)model;

@end
