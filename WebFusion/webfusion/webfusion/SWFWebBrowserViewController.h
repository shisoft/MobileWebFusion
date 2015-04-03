//
// Created by Jack Shi on 4/4/15.
// Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWFWebBrowserViewControllerCore;


@interface SWFWebBrowserViewController : UINavigationController
@property(nonatomic) UIWebView *webView;
@property SWFWebBrowserViewControllerCore *core;
- (instancetype)init;
@end