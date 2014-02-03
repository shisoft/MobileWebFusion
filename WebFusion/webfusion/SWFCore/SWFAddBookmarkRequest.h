//
//  DCAddBookmarkRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@class SWFWrapper;

@interface SWFAddBookmarkRequest : CGIRemoteObject

@property id ID;
@property NSString *group;
@property NSString *note;
@property NSString *later;
@property NSString *svrMark;
@property int type;

@end

@interface SWFAddBookmarkRequest (SWFMethods)

- (SWFWrapper *)addBookmark; // return bookmark id if success, '*' star if exists.

@end
