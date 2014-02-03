//
//  SWFUserContactMethod.h
//  webfusion
//
//  Created by Jack Shi on 13-7-19.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFUserServices.h"
#import "SWFUniversalContact.h"

@interface SWFUserContactMethod : CGIPersistantObject

CGIIdentifierProperty;
@property SWFUserServices *svr;
@property SWFUniversalContact *uc;

@end
