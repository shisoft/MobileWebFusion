//
//  SWFBookmark.h
//  webfusion
//
//  Created by Jack Shi on 13-7-25.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFBookmark : CGIPersistantObject

CGIIdentifierProperty;
@property NSArray *groups;
@property BOOL later;
@property BOOL laterVal;
@property NSString *note;
@property id obj;
@property BOOL svrMark;
@property NSDate *time;
@property int type;
@property id user;

@end
