//
//  SWFContactNewsViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-8-12.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFContactNewsViewController.h"
#import "SWFNewsDelegates.h"
#import "SWFGetUserContactWhatzNewRequest.h"

@interface SWFContactNewsViewController ()

@end

@implementation SWFContactNewsViewController

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
    self.delegates = [[SWFNewsDelegates alloc] initWithWebView:self.webView ViewController:self getNews:^{
        SWFGetUserContactWhatzNewRequest *newsRequest = [[SWFGetUserContactWhatzNewRequest alloc] init];
        newsRequest.count = SWFItemFetchCount;
        newsRequest.lastT = self.delegates.pageLastNewsDate;
        newsRequest.ID = self.uc.ID;
        return [newsRequest getUserContactWhatzNew];
    } name:[@"ucNews" stringByAppendingString:[[NSString alloc] initWithFormat:self.uc.ID]]];
    [self.delegates loadNews];
    self.title = self.uc.name;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
