//
//  SWFNewPostRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-12.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFNewPostContact.h"

@class SWFWrapper;

@interface SWFNewPostRequest : CGIRemoteObject

@property NSString *title;
@property NSString *content;
@property NSString *friendly;
@property NSString *private;
@property NSString  *tags;
@property id base;
@property NSArray *contacts;

@end

@interface SWFNewPostRequest (SWFMethods)

- (SWFWrapper *)newPost;

@end