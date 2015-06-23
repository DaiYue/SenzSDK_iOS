//
//  SNZLocationManager.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/7.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZLocationManager.h"
#import "SNZLocationData.h"
#import "SNZCommonStore.h"

@interface SNZLocationManager ()

@property (nonatomic, strong) CLLocationManager* locationManager;

@end

@implementation SNZLocationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        CLLocationManager* locationManager = [CLLocationManager new];
        locationManager.delegate = self;

        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 10.0;

        [locationManager requestAlwaysAuthorization];

        self.locationManager = locationManager;
    }
    return self;
}

#pragma - Start & Stop listening

- (void)startListening {
//    [self.locationManager startUpdatingLocation];
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopListening {
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

#pragma mark - Handling Location

- (void)boostUpdating {
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"Fetch location failed with error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)nextLocation fromLocation:(CLLocation *)prevLocation {
    SNZLocationData* model = [SNZLocationData dataWithLocation:nextLocation];
    [SNZCommonStore saveDataEventuallyWithModel:model];
}

@end
