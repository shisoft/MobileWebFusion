//
//  SWFBookmarkWrapper.m
//  webfusion
//
//  Created by Jack Shi on 13-7-25.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFBookmarkWrapper.h"

@implementation SWFBookmarkWrapper

@end

@implementation SWFBookmarkWrapper (SWFAccessorMethods)

- (SWFNews *)newsValue{
    return [[SWFNews alloc] initWithPersistanceObject:self.i];
}
- (SWFPost *)postValue{
    return [[SWFPost alloc] initWithPersistanceObject:self.i];
}

@end