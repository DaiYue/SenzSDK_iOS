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

+ (NSString*)deviceUUID;
+ (void)saveDataWithClassName:(NSString*)className dictionary:(NSDictionary*)dictionary;
+ (void)saveDataWithClassName:(NSString*)className model:(JSONModel*)model;

@end
