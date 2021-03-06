//
//  NSArray+Utility.m
//  QunariPhone
//
//  Created by HeYichen on 13-12-24.
//  Copyright (c) 2013年 Qunar.com. All rights reserved.
//

#import "NSArray+SNZUtility.h"

@implementation NSArray (SNZUtility)

- (id)objectAtIndexSafe:(NSUInteger)index
{
    id object = nil;
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
    }
    return object;
}

@end
