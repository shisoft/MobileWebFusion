//
//  SWFUserContactDetails.m
//  webfusion
//
//  Created by Jack Shi on 13-7-19.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFUserContactDetails.h"
#import "SWFUserContactGroup.h"
#import "SWFUserContactMethod.h"

@implementation SWFUserContactDetails

CGIPersistanceKeyClass(ucgs, SWFUserContactGroup);
CGIPersistanceKeyClass(ucls, SWFUserContactMethod);

@end
