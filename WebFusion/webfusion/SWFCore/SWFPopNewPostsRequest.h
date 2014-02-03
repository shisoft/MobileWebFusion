//
//  SWFPopNewPostsRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-9-6.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFPopNewPostsRequest : CGIRemoteObject

@end

@interface SWFPopNewPostsRequest (SWFMethods)

- (void)popNewPosts;

@end