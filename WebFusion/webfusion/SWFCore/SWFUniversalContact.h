//
//  DCUniversalContact.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-24.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFUniversalContact : CGIPersistantObject

CGIIdentifierProperty; // Now this will do the id property. This is just being too ubiqutous to ignore.
@property NSString *dispName; // These keys are copied from Version 4. You should check it.
@property NSString *scrName;
@property NSURL *avatar;
@property NSString *svr;
@property id svrId;

@end
