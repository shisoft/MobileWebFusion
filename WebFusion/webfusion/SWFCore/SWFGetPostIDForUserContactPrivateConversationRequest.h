//
//  SWFGetPostIDForUserContactPrivateConversationRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-10-31.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

#import "SWFWrapper.h"

@interface SWFGetPostIDForUserContactPrivateConversationRequest : CGIRemoteObject

@property id ucid;

@end

@interface SWFGetPostIDForUserContactPrivateConversationRequest (SWFMethods)

- (SWFWrapper *) getPostIDForUserContactPrivateConversation;

@end