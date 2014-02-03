//
//  SWFBookmarkCellViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-25.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFBookmarkCellViewController.h"
#import "SWFUniversalContact.h"
#import "SWFCodeGenerator.h"
#import "NSString+SWFUtilities.h"
#import "SWFAvatarHelper.h"
#import "UIImage+SWFUtilities.h"

@implementation SWFBookmarkCellViewController

-(SWFBookmarkCellViewController*)initWithBookmarkWrapper:(SWFBookmarkWrapper *)bw{
    NSString *content;
    switch (bw.bm.type) {
        case 0:{
            SWFNews *news = [bw newsValue];
            self.avatar = news.authorUC.avatar;
            self.displayname = [SWFCodeGenerator authorDescription:news.authorUC];
            self.title = [news.title stringByStrippingHTML];
            self.type = [UIImage imageNamed:@"news_ind"];
            self.publish = news.publishTime;
            
            content = [news.content stringByStrippingHTML];
        }
            break;
        case 1:
        {
            SWFPost *post = [bw postValue];
            self.avatar = post.authorUC.avatar;
            self.displayname = [SWFCodeGenerator authorDescription:post.authorUC];
            self.title = [post.title stringByStrippingHTML];
            if (post.base == nil) {
                self.type = [UIImage imageNamed:@"post_ind"];
            }else{
                self.type = [UIImage imageNamed:@"topics_ind"];
            }
            self.publish = post.posttime;
            if([post.news isKindOfClass:[SWFNews class]]){
                if([post.news.title isKindOfClass:[NSString class]]){
                    self.title = [post.news.title stringByStrippingHTML];
                }
            }
            
            content = [post.content stringByStrippingHTML];
        }
            break;
        default:
            break;
    }
    if ([bw.bm.note length] > 0) {        
        self.comment = [bw.bm.note stringByStrippingHTML];
    }else{
        self.comment = content;
    }
    return self;
}

-(void)displayInCell:(SWFBookmarkCell*)cell{    cell.authorNameLabel.text = self.displayname;
    cell.titleLabel.text = self.title;
    cell.commentLabel.text = self.comment;
    cell.publishLabel.text = [SWFCodeGenerator timeDescription:self.publish];
    cell.bookmarkTypeIcon.image = self.type;
    cell.bookmarkTypeIcon.highlightedImage = [cell.bookmarkTypeIcon.image maskedImageColor:[UIColor whiteColor]];
    if (cell.bookmarkCellViewController != self) {
        cell.bookmarkCellViewController = self;
        cell.avatarImageView.image = nil;
    }
    if (self.avatarImage == nil) {
        cell.avatarImageView.image = [SWFAvatarHelper displayAvatar:self.avatar callback:^(id img){
            if (cell.bookmarkCellViewController == self) {
                cell.avatarImageView.image = img;
            }
        }];
    }
}

@end
