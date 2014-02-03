//
//  SWFBookmarkWrapper.h
//  webfusion
//
//  Created by Jack Shi on 13-7-25.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFBookmark.h"
#import "SWFNews.h"
#import "SWFPost.h"

@interface SWFBookmarkWrapper : CGIPersistantObject

@property id i;
@property SWFBookmark *bm;

@end

@interface SWFBookmarkWrapper (SWFAccessorMethods)

- (SWFNews *)newsValue;
- (SWFPost *)postValue;

@end