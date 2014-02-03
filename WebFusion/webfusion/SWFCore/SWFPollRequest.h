//
//  SWFPollRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@class SWFWrapper;

@interface SWFPollRequest : CGIRemoteObject


@property NSArray *d;
@property NSInteger i;
@property NSInteger w;

@end

@interface SWFPollRequest (SWFMethods)

- (SWFWrapper *)Poll;

@end
