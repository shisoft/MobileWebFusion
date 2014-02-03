//
//  SWFDeleteBookmarkRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-25.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFDeleteBookmarkRequest : CGIRemoteObject

@property id ID;

@end

@interface SWFDeleteBookmarkRequest (SWFMethods)

- (void *) deleteBookmark;

@end
