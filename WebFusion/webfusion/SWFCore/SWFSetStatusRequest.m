//
//  DCSetStausRequest.m
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import "SWFSetStatusRequest.h"

@implementation SWFSetStatusRequest

#ifdef DCSETSTATUS_MISSPELLED
- (id)setStatus
{
    return [self setStaus];
}
#endif

@end
