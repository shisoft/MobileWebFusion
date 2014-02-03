//
//  SWFUserContactDetails.h
//  webfusion
//
//  Created by Jack Shi on 13-7-19.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFUserContact.h"
#import "SWFUserContactGroup.h"

@interface SWFUserContactDetails : CGIPersistantObject

@property NSArray *ucgs;
@property NSArray *ucls;
@property SWFUserContact *uc;

@end
