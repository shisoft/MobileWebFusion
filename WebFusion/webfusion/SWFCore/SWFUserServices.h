//
//  SWFUserServices.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFUserServices : CGIPersistantObject

CGIIdentifierProperty;
@property NSString *account;
@property NSString *gate;

@end
