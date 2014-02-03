//
//  SWFPostDetailsViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-10.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFPostDetailsViewController.h"
#import "SWFGetPostsByBIDRequest.h"
#import "SWFCodeGenerator.h"
#import "SWFWebBrowserViewController.h"
#import "SWFInputActionViewController.h"
#import "NSString+SWFUtilities.h"

@interface SWFPostDetailsViewController ()

@end

@implementation SWFPostDetailsViewController

@synthesize currentPage;
@synthesize busy;
@synthesize replies;
@synthesize actionSheet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        replies = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"ui.cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ui.reply", @""),NSLocalizedString(@"ui.repost", @""),NSLocalizedString(@"ui.bookmark", @""),NSLocalizedString(@"ui.read-later", @""), nil];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.webView.scrollView addSubview:self.refreshControl]; //<- this is point to use. Add "scrollView" property.
    self.navigationItem.leftBarButtonItem  = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.title = [[SWFCodeGenerator getPostTitle:self.post] stringByStrippingHTML];
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [[UIColor alloc] initWithRed:211 /255.0 green:211 / 255.0 blue:211 / 255.0 alpha:1.0];
    [self.webView setOpaque:NO];
    [self refresh];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
}

- (void) refresh{
    currentPage = 0;
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:[SWFCodeGenerator generateForPostPage:self.post] baseURL:baseURL];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadPostReplies{
    if ([self.post.reply intValue] == 0) {
        return;
    }
    if(currentPage == 0){
        [self.webView stringByEvaluatingJavaScriptFromString:@"loading()"];
    }
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWFGetPostsByBIDRequest *postRequest = [[SWFGetPostsByBIDRequest alloc] init];
        postRequest.bid = self.post.ID;
        postRequest.page = currentPage;
        NSArray *postResponse = [postRequest getPostsByBID];
        if(![postResponse isKindOfClass:[NSArray class]]){
            return;
            busy = NO;
        }
        NSMutableString *items = [NSMutableString stringWithString:@""];
        for (SWFPost *postItem in postResponse)
        {
            [items appendString:[SWFCodeGenerator generateForPost:postItem]];
            [replies setObject:postItem forKey:postItem.ID];
            
        }
        NSString *tempPath = NSTemporaryDirectory();
        NSString *path = [tempPath stringByAppendingPathComponent:@"dispPostReplies.txt"];
        NSError *err;
        [items writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"append('%@')",path]];
            busy = NO;
        });
    });
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if([requestString hasPrefix:@"file://"] || [requestString hasPrefix:@"about:"]){
        return YES;
    } else if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"swf"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"nextpage"])
        {
            if(!busy){
                self.currentPage++;
                [self loadPostReplies];
            }
        }else if ([(NSString *)[components objectAtIndex:1] isEqualToString:@"action"]){
            self.activePostId = (NSString *)[components objectAtIndex:2];
            [self.actionSheet showInView:self.view];
        }else if ([(NSString *)[components objectAtIndex:1] isEqualToString:@"loaded"]){
            [self loadPostReplies];
        }else if ([(NSString *)[components objectAtIndex:1] isEqualToString:@"subpost"]){
            SWFPostDetailsViewController *pdvc = [[SWFPostDetailsViewController alloc] initWithNibName:@"SWFPostDetailsViewController" bundle:nil];
            SWFPost *reply = [replies objectForKey:[components  objectAtIndex:2]];
            pdvc.post = reply;
            [self.navigationController pushViewController:pdvc animated:YES];
        }
    }else{
        if (navigationType == UIWebViewNavigationTypeLinkClicked) {            SWFWebBrowserViewController *browser = [[SWFWebBrowserViewController alloc] initWithNibName:@"SWFWebBrowserViewController" bundle:nil];
            [self presentViewController:browser animated:YES completion:nil];
            [browser.webView loadRequest:request];
        }
    }
    return NO;
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex != self.actionSheet.cancelButtonIndex){
        SWFInputActionViewController *niavc = [[SWFInputActionViewController alloc] initWithNibName:@"SWFInputActionViewController" bundle:nil];
        niavc.action = buttonIndex;
        niavc.postId = self.activePostId;
        niavc.PostDetailsViewController = self;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:niavc];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

@end
