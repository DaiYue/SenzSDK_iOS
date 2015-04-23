//
//  AppDelegate.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/7.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AVOSCloud setApplicationId:@"qej9ne5a3hbh8cia69gpzftd9dly03zj4s3ni6bm0y4oixn4"
                      clientKey:@"g2kjihzio1abmdq3jl0se7a2p5ferlgh6tyeqdgzkyfxfajx"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
