//
//  SWFNewsViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-1.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFNewsRequest.h"
#import "SWFCodeGenerator.h"
#import "SWFNewsViewController.h"
#import "SWFAppDelegate.h"
#import "SWFComposeNewsViewController.h"
#import "SWFWebBrowserViewController.h"
#import "SWFNewsDelegates.h"
#import "SWFNewsPoll.h"

@interface SWFNewsViewController ()

@end

@implementation SWFNewsViewController

@synthesize newsWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"func.news", @"");
        [[SWFPoll defaultPoll] addDelegate:self forKey:@"newsc"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"func.news", @"");
    self.delegates = [[SWFNewsDelegates alloc] initWithWebView:self.newsWebView ViewController:self getNews:^{
        SWFNewsRequest *newsRequest = [[SWFNewsRequest alloc] init];
        newsRequest.count = SWFItemFetchCount;
        newsRequest.lastT = self.delegates.pageLastNewsDate;
        return [newsRequest getWhatzNew];
    } name:@"news"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    __block SWFNewsViewController *this = self;
    self.delegates.loadCompleted = ^{
        this.badgeNum = 0;
        if (this.refBadge != nil){
            this.refBadge();
        }
        [[SWFPoll defaultPoll] repoll];
    };
    [self.delegates loadNews];
    [self.delegates manualBottomInsets];
    
}

- (void)viewWillAppear:(BOOL)animated{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        bool canSend = [[SWFAppDelegate getDefaultInstance] hasFeature:@"CanBoradcast,CanBoradcastImage,CanBoradcastBlog"];
        dispatch_async(dispatch_get_main_queue(),^{
            self.navigationItem.rightBarButtonItem.enabled = canSend;
        });
    });
}

- (void)compose{
    SWFComposeNewsViewController *cnvc = [[SWFComposeNewsViewController alloc] initWithNibName:@"SWFComposeNewsViewController" bundle:nil];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cnvc];
    [[SWFAppDelegate getDefaultInstance].rootViewController presentViewController:nvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)poll:(SWFPoll *)poll objectForKey:(NSString *)key
{
    if (!self.delegates.isEmpty)
    {
        SWFNewsPoll *poll = [[SWFNewsPoll alloc] init];
        poll.dvt = self.badgeNum;
        poll.lt = self.delegates.latestNewsDate;
        return poll;
    }
    else
    {
        return nil;
    }
}

- (void)poll:(SWFPoll *)poll receivedObject:(id)object forKey:(NSString *)key
{
    if ([object respondsToSelector:@selector(integerValue)])
    {
        self.badgeNum = [object integerValue];
    }
    if (self.refBadge != nil){
        self.refBadge();
    }
}

- (NSInteger) getBadgeNum{
    return self.badgeNum;
}

@end
