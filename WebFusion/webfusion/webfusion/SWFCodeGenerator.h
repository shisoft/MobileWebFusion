//
//  SWFNewsDisplayCodeGenerator.h
//  webfusion
//
//  Created by Jack Shi on 13-7-2.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWFNews.h"
#import "SWFPost.h"

@interface SWFCodeGenerator : NSObject

+ (NSString*)generateForNewsArray:(NSArray*)news;
+ (NSString*)generateForNews:(SWFNews*)newsItem level:(int)level;
+ (NSString *)timeDescription:(NSDate*)date;
+ (NSString *)authorDescription:(SWFUniversalContact*)authorUC;
+ (NSString *) getPostTitle : (SWFPost*) post;

+ (NSString*)generateForPostPage : (SWFPost*) post;
+ (NSString*)generateForPost : (SWFPost*) post;

+ (NSString*)hideHideTags : (NSString*) str;

+ (NSString*)generateForConvPostArray:(NSArray*)posts;

+ (NSString*)generateForConversationPOST: (SWFPost*) post;

@end
