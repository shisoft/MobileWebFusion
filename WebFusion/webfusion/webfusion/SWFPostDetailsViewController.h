//
//  SWFPostDetailsViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-10.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFNavedCenterViewController.h"
#import "SWFPost.h"
#import "SWFTrackedViewController.h"

@interface SWFPostDetailsViewController : SWFTrackedViewController <UIActionSheetDelegate>

@property UIRefreshControl *refreshControl;
@property SWFPost *post;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property int currentPage;
@property BOOL busy;
@property NSMutableDictionary *replies;
@property UIActionSheet* actionSheet;
@property id activePostId;

- (void) refresh;

@end
