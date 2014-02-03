//
//  SWFNewThreadCountPoll.m
//  webfusion
//
//  Created by Jack Shi on 13-11-2.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFNewThreadCountPoll.h"

@implementation SWFNewThreadCountPoll

- (void)awakeFromPersistance:(id)persistance
{
    self.t = @"thc";
    self.thvt = 0;
}

@end
