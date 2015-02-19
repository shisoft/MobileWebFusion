//
//  SWFSingleNewsViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-16.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFSingleNewsViewController.h"
#import "SWFNews.h"
#import "SWFNewsDelegates.h"

@interface SWFSingleNewsViewController ()

@end

@implementation SWFSingleNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.delegates) {
        return;
    }
    self.webView.scrollView.bounces = NO;
    if ([self.navigationController.viewControllers objectAtIndex:0] == self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelButtonPressed)];
    }
    self.delegates = [[SWFNewsDelegates alloc] initWithWebView:self.webView ViewController:self getNews:^{
        if (self.delegates.currentPage > 0) {
            return [[NSArray alloc] init];
        }else{
            return [[NSArray alloc] initWithObjects:self.news, nil];
        }
    } name:nil];
    __block SWFSingleNewsViewController *this = self;
    self.delegates.loadCompleted = ^{
        [this.webView stringByEvaluatingJavaScriptFromString:@"stopLoading()"];
    };
    [self.delegates loadNews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
