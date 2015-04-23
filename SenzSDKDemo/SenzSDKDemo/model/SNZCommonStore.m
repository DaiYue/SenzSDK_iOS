//
//  SNZCommonStore.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZCommonStore.h"
#import <AVOSCloud/AVOSCloud.h>
#import "JSONModel.h"

@implementation SNZCommonStore

+ (NSString*)deviceUUID {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* deviceUUID = [userDefaults objectForKey:@"deviceUUID"];
    if (deviceUUID == nil) {
        deviceUUID = [[NSUUID UUID] UUIDString];
        [userDefaults setObject:deviceUUID forKey:@"deviceUUID"];
    }

    return deviceUUID;
}

+ (void)saveDataWithClassName:(NSString*)className dictionary:(NSDictionary*)dictionary {
    if (dictionary == nil) {
        return;
    }

    AVObject* object = [AVObject objectWithClassName:className dictionary:dictionary];
    [object saveInBackground];
}

+ (void)saveDataWithClassName:(NSString*)className model:(JSONModel*)model {
    if (model == nil) {
        return;
    }

    NSLog(@"[%@] %@", className, [model toJSONString]);

    AVObject* object = [AVObject objectWithClassName:className dictionary:[model toDictionary]];
    [object saveInBackground];
}


@end
