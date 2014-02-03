//
//  SWFNewsPoll.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-28.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import "SWFNewsPoll.h"

@implementation SWFNewsPoll

- (void)awakeFromPersistance:(id)persistance
{
    self.t = @"newsc";
    self.exceptions = @"";
    self.type = @"";
}

@end
