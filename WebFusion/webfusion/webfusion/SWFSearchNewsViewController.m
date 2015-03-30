//
//  SWFSearchNewsViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-26.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFSearchNewsViewController.h"
#import "SWFSearchNewsRequest.h"
#import "SWFNews.h"
#import "SWFCodeGenerator.h"
#import "SWFWebBrowserViewController.h"
#import "SWFNewsDelegates.h"

@interface SWFSearchNewsViewController ()

@end

@implementation SWFSearchNewsViewController

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
    self.navigationController.navigationBar.translucent = NO;
    self.title = NSLocalizedString(@"func.SearchNews", @"");
    [self.searchBar becomeFirstResponder];
    self.delegates = [[SWFNewsDelegates alloc] initWithWebView:self.webView ViewController:self getNews:^id{
        SWFSearchNewsRequest *snr = [[SWFSearchNewsRequest alloc] init];
        snr.kw = self.kw;
        snr.page = self.delegates.currentPage;
        return [snr searchNews];
    } name:nil];
    __block SWFSearchNewsViewController *this = self;
    self.delegates.loadCompleted = ^(void){
        [this.searchBar resignFirstResponder];
    };
    [self.delegates manualBottomInsets];
    //[super changeNavBarColor:[[UIColor alloc] initWithRed:27 / 255.0 green:110 / 255.0 blue:177 / 255.0 alpha:1.0]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadNews{
    [self.delegates resetParameteres];
    [self.delegates loadNews];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.kw = self.searchBar.text;
    [self reloadNews];
}

@end
