//
//  SNZBeaconManager.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZBeaconManager.h"

@interface SNZBeaconManager()

@property CLLocationManager* locationManager;

@property NSString* observingUUID;
@property NSNumber* observingMajor;
@property NSNumber* observingMinor;

@property id startRangingTarget;
@property SEL startRangingCallback;

@property NSMutableArray* rangingRegionArray;

@end

@implementation SNZBeaconManager

-(id)init{
    if (self = [super init]) {
        self.beaconUUIDArray = @[@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];

        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }

    return self;
}

#pragma mark - Start Ranging

- (void)startListening {
    //start ranging
    self.rangingRegionArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.beaconUUIDArray.count; i++) {
        [self startRangingWithUUID:self.beaconUUIDArray[i]];
    }
}

- (void)stopListening {
    CLLocationManager* locationManager = self.locationManager;
    if (self.rangingRegionArray != nil) {
        for (int i = 0; i < self.rangingRegionArray.count; i++) {
            CLBeaconRegion* region = self.rangingRegionArray[i];

            [locationManager stopMonitoringForRegion:region];
            [locationManager stopRangingBeaconsInRegion:region];

            [self locationManager:locationManager didExitRegion:region];
        }
    }
}

- (void)startRangingWithUUID:(NSString*)beaconID{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:beaconID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:beaconID];
    if (region == nil) {
        return;  //Illegal UUID
    }

    [self.rangingRegionArray addObject:region];
    [self.locationManager startMonitoringForRegion:region];
    [self.locationManager startRangingBeaconsInRegion:region];
}

#pragma mark - Observer Mode

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    if (beacons.count == 0) {
        return;
    }

    NSString* regionUUID = [region.proximityUUID UUIDString];
    NSLog(@"regionUUID : %@", regionUUID);
    NSLog(@"beacons : %@", beacons);
}


@end
