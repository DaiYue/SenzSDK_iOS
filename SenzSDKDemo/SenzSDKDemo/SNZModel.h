//
//  SNZModel.h
//  SenzSDKDemo
//
//  Created by yue.dai on 15/6/6.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "JSONModel.h"
#import <AVOSCloud/AVOSCloud.h>

@interface SNZModel : JSONModel

- (AVObject*)avObject;

// override this method
- (NSString*)avClassName;

@end
