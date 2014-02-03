//
//  SWFTopicCellViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-10.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWFPost.h"
#import "SWFUITopicCell.h"

@class SWFUITopicCell;

typedef void (^openMSGC)(void);

@interface SWFTopicCellViewController : NSObject

@property  NSURL  *avatar;
@property  UIImage *avatarData;
@property  NSString *author;
@property  NSDate *publish;
@property  NSString *title;
@property  NSString *content;
@property  NSString *threads;
@property  SWFPost  *post;
@property  SWFUITopicCell *cell;
@property UIViewController *uivc;

@property (nonatomic, strong) openMSGC openMSGC;

- (SWFTopicCellViewController*) initWithPost : (SWFPost*)post UIVC:(UIViewController*)uivc;

-(void) displayAvatar;


@end
