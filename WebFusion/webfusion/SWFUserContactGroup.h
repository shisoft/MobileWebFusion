//
//  SWFUserContactGroup.h
//  webfusion
//
//  Created by Jack Shi on 13-7-19.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFUserContactGroup : CGIPersistantObject

CGIIdentifierProperty;
@property NSArray *contacts;
@property id user;
@property NSString *name;

@end
