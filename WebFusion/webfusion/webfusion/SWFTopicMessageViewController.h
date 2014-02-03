//
//  SWFUserContactPrivateConversationViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-10-31.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFNavedCenterViewController.h"
#import "SWFPost.h"
#import "SWFUserContact.h"
#import "SWFPoll.h"

@interface SWFTopicMessageViewController : SWFNavedCenterViewController <UIWebViewDelegate, UITextFieldDelegate, SWFPollDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) IBOutlet UITextField *txMessage;
@property (strong, nonatomic) IBOutlet UIToolbar *composeBar;
@property (strong, nonatomic) UIProgressView *progressbar;

@property UIRefreshControl *refreshControl;

@property id RootIDToReply;
@property id UserContactID;

@property int currentPage;

@property (strong, atomic) NSMutableArray *newestPosts;

-(void)loadRootedPosts:(SWFPost*) post;
- (void)loadUserContactPrivateConversation:(SWFUserContact*)uc;

@end
