//
//  SWFGetUserBookmarksRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-25.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetUserBookmarksRequest : CGIRemoteObject

@property int page;

@end

@interface SWFGetUserBookmarksRequest (SWFMethods)

- (NSArray *) getUserBookmarks;

@end

