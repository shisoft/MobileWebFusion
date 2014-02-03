//
//  SWFGateInfo.h
//  webfusion
//
//  Created by Jack Shi on 13-7-24.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGateInfo : CGIPersistantObject

@property NSString *addServiceHTML;
@property NSString *classCode;
@property NSString *code;
@property BOOL hasContact;
@property int level;
@property NSString *name;
@property NSString *upStr;

@end
