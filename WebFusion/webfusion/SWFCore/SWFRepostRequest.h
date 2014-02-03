//
//  DCRepostRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFRepostRequest : CGIRemoteObject

@property id ID;
@property NSString *content;
@property NSString *exceptions;
@property NSString *audience;

@end

@interface SWFRepostRequest (SWFMethods)

- (id)repost;

@end