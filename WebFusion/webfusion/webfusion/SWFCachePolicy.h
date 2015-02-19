//
// Created by Jack Shi on 19/2/15.
// Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CGIJSONObject/CGICommon.h>


@interface SWFCachePolicy : NSObject

+ (NSString *) cacheFilePathWithFileName:(NSString *) fileName;
+ (void) cacheInWithData:(NSCoder *) data fileName:(NSString *)fileName;
+ (NSCoder *) cacheOutWithFileName:(NSString *)fileName;


@end