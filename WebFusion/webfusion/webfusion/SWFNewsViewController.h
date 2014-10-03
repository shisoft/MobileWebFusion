//
//  SWFNewsViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-1.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFTrackedViewController.h"
#import "SWFNews.h"
#import "SWFNewsDelegates.h"
#import "SWFPoll.h"

@interface SWFNewsViewController : SWFTrackedViewController <SWFPollDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *newsWebView;
@property int unread;

@property SWFNewsDelegates *delegates;

@end
