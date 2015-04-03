//
// Created by Jack Shi on 4/4/15.
// Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import "SWFWebBrowserViewController.h"
#import "SWFWebBrowserViewControllerCore.h"


@implementation SWFWebBrowserViewController {

}
- (instancetype)init {
    self.core = [[SWFWebBrowserViewControllerCore alloc] initWithNibName:@"SWFWebBrowserViewControllerCore" bundle:nil];
    self = [self initWithRootViewController:self.core];
    return self;
}

-(UIWebView *)webView {
    return [self.core webView];
}

- (void)viewDidLoad {
    [self.core loadView];
    [self.core viewDidLoad];
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


@end