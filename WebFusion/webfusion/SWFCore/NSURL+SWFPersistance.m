//
//  NSURL+SWFPersistance.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-24.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import "NSURL+SWFPersistance.h"

@implementation NSURL (SWFPersistance)

- (id)initWithPersistanceObject:(id)persistance
{
    if ([persistance isKindOfClass:[NSString class]])
    {
        return [self initWithString:persistance];
    }
    else
    {
        return persistance;
    }
}

- (id)persistaceObject
{
    return [self absoluteString];
}

@end
