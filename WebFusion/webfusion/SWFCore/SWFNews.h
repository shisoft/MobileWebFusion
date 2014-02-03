//
//  SWFNews.h
//  Deuterium
//
//  Created by John Shi on 13-5-22.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@class SWFUniversalContact;
@class CLLocation;
@class SWFPOI;

@interface SWFNews : CGIPersistantObject

CGIIdentifierProperty;
@property NSString *content;
@property NSString *title;
@property NSURL *href;
@property CLLocation *location;
@property NSDate *publishTime;
@property SWFUniversalContact *authorUC;
@property NSArray *medias;
@property NSString *lang;
@property SWFNews *refer;
@property NSString *svr;
@property NSString *type;
@property id tag;
@property NSDictionary *additionalClue; // for search
@property int abuse;
@property SWFPOI *POI;


@end
