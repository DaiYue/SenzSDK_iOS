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

        [locationManager requestWhenInUseAuthorization];

        self.locationManager = locationManager;
    }
    return self;
}

- (void)fetchLocation {
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Fetch location failed with error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];

    SNZLocationData* model = [SNZLocationData dataWithLocation:newLocation];
    [SNZCommonStore saveDataWithClassName:@"Location" model:model];
}

@end
