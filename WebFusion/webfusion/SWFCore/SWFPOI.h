//
//  SWFPOI.h
//  webfusion
//
//  Created by Jack Shi on 13-8-28.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@class CLLocation;

@interface SWFPOI : CGIPersistantObject

CGIIdentifierProperty;
@property NSString *innid;
@property NSString *name;
@property CLLocation *location;
@property NSString *country;
@property NSArray *phone;
@property NSString *locClass;
@property NSDate *uploadTime;
@property NSString *pid;
@property NSString *address;
@property long hits;
@property NSString *type;
@property NSString *lang;
@property NSString *street;
@property NSString *province;
@property NSString *city;

@end
