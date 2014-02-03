//
//  SWFNewsTrendWrapper.h
//  webfusion
//
//  Created by Jack Shi on 13-7-27.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFNewsTrendWrapper : CGIPersistantObject

@property double mod;
@property NSArray* data;
@property int acc;
@property NSArray *qss;

@end
