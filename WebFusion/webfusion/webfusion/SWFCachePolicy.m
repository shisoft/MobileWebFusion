//
// Created by Jack Shi on 19/2/15.
// Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGICommon.h>
#import "SWFCachePolicy.h"


@implementation SWFCachePolicy {



}

+ (NSString *)cacheFilePathWithFileName:(NSString *)fileName {
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [[cachePaths objectAtIndex:0] stringByAppendingString:fileName];
}

+ (void)cacheInWithData:(id)data fileName:(NSString *)fileName {
    [NSKeyedArchiver archiveRootObject:data toFile:[self cacheFilePathWithFileName:fileName]];
}

+ (id)cacheOutWithFileName:(NSString *)fileName {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self cacheFilePathWithFileName:fileName]];
}


@end