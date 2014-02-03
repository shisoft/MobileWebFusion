//
//  DCDiscoveryRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFDiscoveryRequest : CGIRemoteObject

@property NSDate *beforeT;
@property NSUInteger count;
@property NSDate *lastT;
@property double threshold;
@property NSArray *topics;

@end

@interface SWFDiscoveryRequest (SWFMethods)

- (NSArray *)streamDiscover;

@end