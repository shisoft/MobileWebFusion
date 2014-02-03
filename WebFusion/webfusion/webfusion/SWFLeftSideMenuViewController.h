//
//  SWFLeftSideMenuViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-1.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "QuickDialogController.h"
#import "QLabelElement.h"
#import "SWFPoll.h"

@interface SWFLeftSideMenuViewController : QuickDialogController <SWFPollDelegate>

@property BOOL firstAppear;
@property (atomic, strong) QLabelElement *userNameLabel;
@property (atomic, strong) QBadgeElement *newsBadge;
@property (atomic, strong) QBadgeElement *threadBadge;

@property int newThreadCount;

-(void) reloadList;

@end
