//
//  ViewController.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/7.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "ViewController.h"
#import "SNZUserDataLogger.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

@property (nonatomic, strong) SNZUserDataLogger* logger;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logger = [SNZUserDataLogger new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playOrStop:(id)sender {
    self.startStopButton.selected = !self.startStopButton.selected;
    if (self.startStopButton.selected) {
        [self.logger startLogging];
    }
    else {
        [self.logger stopLogging];
    }
}

@end
