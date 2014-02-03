//
//  SWFUserContactLink.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-30.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFUserContactLink : CGIPersistantObject

CGIIdentifierProperty;
@property id svr;
@property id uc;
@property id user;

@end
