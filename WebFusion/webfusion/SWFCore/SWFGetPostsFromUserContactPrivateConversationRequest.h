//
//  SWFGetPostsFromUserContactPrivateConversationRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-10-31.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetPostsFromUserContactPrivateConversationRequest : CGIRemoteObject

@property id ucid;
@property int page;

@end

@interface SWFGetPostsFromUserContactPrivateConversationRequest (SWFMethods)

- (NSArray *) getPostsFromUserContactPrivateConversation;

@end