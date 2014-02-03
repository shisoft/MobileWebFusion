//
//  SWFNewPostRequest.m
//  webfusion
//
//  Created by Jack Shi on 13-7-12.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFNewPostRequest.h"
#import "SWFNewPostContact.h"

@implementation SWFNewPostRequest


CGIPersistanceKeyClass(contacts, SWFNewPostContact);
CGIRemoteMethodClass(newPost, SWFWrapper);

@end
