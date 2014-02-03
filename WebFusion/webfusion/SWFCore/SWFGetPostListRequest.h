//
//  SWFGetPostListRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-10.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetPostListRequest : CGIRemoteObject

@property NSString *type;
@property int page;
@property id contact;

@end


@interface SWFGetPostListRequest (SWFMethods)

- (NSArray*)getPostList;

@end