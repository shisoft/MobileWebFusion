//
//  SWFSingleNewsViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-16.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFNews.h"
#import "SWFNewsDelegates.h"
#import "SWFTrackedViewController.h"

@interface SWFSingleNewsViewController : SWFTrackedViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property SWFNews *news;

@property SWFNewsDelegates *delegates;

@end
