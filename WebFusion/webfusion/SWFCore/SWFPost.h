//
//  SWFPost.h
//  webfusion
//
//  Created by Jack Shi on 13-7-10.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFNews.h"

@class SWFUniversalContact;

@interface SWFPost : CGIPersistantObject

CGIIdentifierProperty;
@property NSString *aid;
@property NSString *title;
@property NSArray *tags;
@property NSString *content;
@property NSString *author;
@property SWFUniversalContact *authorUC;
@property NSDate *posttime;
@property id base;
@property BOOL isfriendly;
@property BOOL isprivate;
@property id root;
@property NSNumber *reply;
@property NSNumber *viewed;
@property NSDate *datereply;
@property SWFUniversalContact *replyAuthorUC;
@property NSString *edited;
@property NSNumber *agreed;
@property NSNumber *disagreed;
@property NSArray *UserPostContacts;
@property NSString *lang;
@property NSArray *ContactsUC;
@property NSArray *svrNews;
@property SWFNews *news;

    
@end
