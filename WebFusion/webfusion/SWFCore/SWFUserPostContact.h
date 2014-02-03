//
//  SWFUserPostContact.h
//  webfusion
//
//  Created by Jack Shi on 13-7-10.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFUserPostContact : CGIPersistantObject

CGIIdentifierProperty;
@property id ucid;
@property id svr;
@property id dvr;
@property id user;
@property id post;

@end
