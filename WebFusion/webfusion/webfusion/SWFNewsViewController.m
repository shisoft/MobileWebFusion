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
@synthesize navItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"func.news", @"");
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
    }];
    [[SWFPoll defaultPoll] addDelegate:self
                                forKey:@"newsc"];
    __block SWFNewsViewController *this = self;
    self.delegates.loadCompleted = ^{
        this.unread = 0;
        [this refreshBadge];
        [[SWFPoll defaultPoll] repoll];
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.delegates loadNews];
    [self.delegates manualBottomInsets];
    
}

- (void)viewWillAppear:(BOOL)animated{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        bool canSend = [[SWFAppDelegate getDefaultInstance] hasFeature:@"CanBoradcast,CanBoradcastImage,CanBoradcastBlog"];
        dispatch_async(dispatch_get_main_queue(),^{
            self.navItem.rightBarButtonItem.enabled = canSend;
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
        poll.dvt = self.unread;
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
        self.unread = [object integerValue];
    }
    [self refreshBadge];
}

- (void)refreshBadge{
    dispatch_async(dispatch_get_main_queue(), ^{
//        SWFLeftSideMenuViewController *sideBar = [SWFAppDelegate getDefaultInstance].leftSidebar;
//        if (self.unread > 0)
//        {
//            sideBar.newsBadge.badge = [NSString stringWithFormat:@"%d", self.unread];
//        }else{
//            sideBar.newsBadge.badge = nil;
//        }
//        [sideBar reloadList];
    });
}

@end
