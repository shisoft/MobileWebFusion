//
//  SWFAddServiceViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-23.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFServicesViewController.h"
#import "SWFTrackedViewController.h"

@interface SWFAddServiceViewController : SWFTrackedViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *servicePickerView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property NSArray *gates;

@property NSString *randomHash;

- (void)setAuthCode:(NSString*)code query:(NSString*)query;

@property SWFServicesViewController *userServiceListView;

@end
