//
//  SNZCommonStore.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSONModel;

@interface SNZCommonStore : NSObject

// == Common Data ==
+ (NSString*)deviceUUID;

// == DB or LeanCloud ==
+ (void)saveDataEventuallyWithClassName:(NSString*)className model:(JSONModel*)model;

// == LeanCloud ==
+ (void)saveDataWithClassName:(NSString*)className dictionary:(NSDictionary*)dictionary;
+ (void)saveDataWithClassName:(NSString*)className model:(JSONModel*)model;

@end
