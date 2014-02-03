//
//  NSDate+SWFPersistance.m
//  Deuterium
//
//  Created by John Shi on 13-5-22.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import "NSDate+SWFPersistance.h"

@implementation NSDate (SWFPersistance)

- (id)initWithPersistanceObject:(id)persistance
{
    if ([persistance respondsToSelector:@selector(longLongValue)])
    {
        long long timestamp = [persistance longLongValue];
        if (timestamp < 0)
        {
            return [NSDate distantPast];
        }
        else
        {
            NSTimeInterval interval = (NSTimeInterval)timestamp / 1000.0;
            return [NSDate dateWithTimeIntervalSince1970:interval];
        }
    }
    else
    {
        return persistance;
    }
}

- (id)persistaceObject
{
    if ([self isEqualToDate:[NSDate distantFuture]] || [self isEqualToDate:[NSDate distantPast]])
        return @(-1000);
    else
    {
        NSTimeInterval interval = [self timeIntervalSince1970];
        return @((long long)(interval * 1000.0));
    }
}

@end
