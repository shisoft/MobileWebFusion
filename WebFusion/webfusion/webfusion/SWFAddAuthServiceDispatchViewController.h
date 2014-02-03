//
//  SWFAddAuthServiceDispatchViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-24.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFAddServiceViewController.h"
#import "SWFTrackedViewController.h"

@interface SWFAddAuthServiceDispatchViewController : SWFTrackedViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property SWFAddServiceViewController *asvc;
@property NSURLRequest *requestToDispatch;

@end
