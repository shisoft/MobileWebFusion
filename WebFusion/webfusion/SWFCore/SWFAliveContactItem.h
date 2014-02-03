//
//  SWFAliveContactItem.h
//  webfusion
//
//  Created by Jack Shi on 13-10-28.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFUserServices.h"
#import "SWFUserContact.h"

@interface SWFAliveContactItem : CGIPersistantObject

@property SWFUserServices *us;
@property SWFUserContact *uc;

@end
