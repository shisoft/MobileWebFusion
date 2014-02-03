//
//  DCGetUserTopicDistRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetUserTopicDistRequest : CGIRemoteObject

@end

@interface SWFGetUserTopicDistRequest (SWFMethods)

- (NSArray *)getUserTopicDist;

@end