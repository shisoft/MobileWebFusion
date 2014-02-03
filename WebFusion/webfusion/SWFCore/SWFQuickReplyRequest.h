//
//  DCQuickReplyRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@class SWFWrapper;

@interface SWFQuickReplyRequest : CGIRemoteObject

@property NSString *content;
@property id ID;

@end

@interface SWFQuickReplyRequest (SWFMethods)

- (SWFWrapper *)quickReply;

@end

