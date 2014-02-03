//
//  SWFUserContact.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-30.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@class SWFUniversalContact;

@interface SWFUserContact : CGIPersistantObject

CGIIdentifierProperty;
@property id user;
@property NSArray *ucs;
@property NSString *name;
@property SWFUniversalContact *avatar;

@end
