//
//  SWFTopicCellViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-10.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFTopicCellViewController.h"
#import "SWFCodeGenerator.h"
#import "SWFPost.h"
#import "NSString+SWFUtilities.h"
#import "SWFUniversalContact.h"
#import "SWFAvatarHelper.h"
#import "SWFAppDelegate.h"
#import "UIImage+SWFUtilities.h"
#import "NSString+URLEncode.h"
#import "SWFTopicMessageViewController.h"
#import "NSString+SWFUtilities.h"

NSMutableDictionary *SWFAvatarQueues;

@implementation SWFTopicCellViewController

@synthesize avatar;
@synthesize avatarData;
@synthesize author;
@synthesize title;
@synthesize content;
@synthesize threads;
@synthesize cell;


- (SWFTopicCellViewController*) initWithPost : (SWFPost*)post UIVC:(UIViewController*)uivc{
    self.post = post;
    self.author = [SWFCodeGenerator authorDescription:post.authorUC];
    self.title = [post.title stringByStrippingHTML];
    self.content = [post.content stringByStrippingHTML];
    self.threads = [NSString stringWithFormat:@"%@",post.reply];
    self.avatar = post.authorUC.avatar;
    self.publish = post.posttime;
    self.uivc = uivc;
    self.openMSGC = ^{
        SWFTopicMessageViewController *ucpcvc = [[SWFTopicMessageViewController alloc] init];
        ucpcvc.title = [SWFCodeGenerator getPostTitle:post];
        [uivc.navigationController pushViewController:ucpcvc animated:YES];
        [ucpcvc loadRootedPosts:post];
    };
    if([post.news isKindOfClass:[SWFNews class]]){
        if([post.news.title isKindOfClass:[NSString class]]){
            self.title = [post.news.title stringByStrippingHTML];
        }
        if([post.news.content isKindOfClass:[NSString class]]){
            self.content = [post.news.content stringByStrippingHTML];
        }
    }
    return self;
}

-(void) displayAvatar{
    if(avatarData == nil){
        avatarData = [SWFAvatarHelper displayAvatar:avatar callback:^(id img){
            avatarData = img;
            cell.avatarImage.image = avatarData;
        }];
        cell.avatarImage.image = avatarData;
    }else{
        cell.avatarImage.image = avatarData;
    }
}

@end
