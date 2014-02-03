//
//  SWFPost.m
//  webfusion
//
//  Created by Jack Shi on 13-7-10.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFPost.h"
#import "SWFUserPostContact.h"
#import "SWFUniversalContact.h"
#import "SWFSvrNews.h"

@implementation SWFPost

CGIPersistanceKeyClass(tags, NSString);
CGIPersistanceKeyClass(UserPostContacts, SWFUserPostContact);
CGIPersistanceKeyClass(ContactsUC, SWFUniversalContact);
CGIPersistanceKeyClass(svrNews, SWFSvrNews);


@end
