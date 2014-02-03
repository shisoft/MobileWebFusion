//
//  SWFWebBrowserViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-7.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFTrackedViewController.h"

@interface SWFWebBrowserViewController : SWFTrackedViewController <UIWebViewDelegate, UIActionSheetDelegate>
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)forwardButtonPressed:(id)sender;
- (IBAction)reloadButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonBack;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonForward;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonReolad;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonAction;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@end
