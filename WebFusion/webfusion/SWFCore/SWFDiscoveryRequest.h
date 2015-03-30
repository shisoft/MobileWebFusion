//
//  DCDiscoveryRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import <CGIJSONObject/CGICommon.h>

@interface SWFDiscoveryRequest : CGIRemoteObject

@property NSDate *before;
@property NSUInteger count;
@property NSString *cats;

@end

@interface SWFDiscoveryRequest (SWFMethods)

- (NSArray *)streamDiscover;

@end