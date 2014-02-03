//
//  SWFGetContactsForPostRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-15.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetContactsForPostRequest : CGIRemoteObject

@end

@interface SWFGetContactsForPostRequest (SWFMethods)

- (NSArray *)getContactsForPost;

@end