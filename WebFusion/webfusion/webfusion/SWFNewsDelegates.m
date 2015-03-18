//
//  SWFNewsDelegates.m
//  webfusion
//
//  Created by Jack Shi on 13-8-11.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGICommon.h>
#import "SWFNewsDelegates.h"
#import "SWFWebBrowserViewController.h"
#import "SWFInputActionViewController.h"
#import "SWFCodeGenerator.h"
#import "SWFReportAbuseViewController.h"
#import "SWFCachePolicy.h"
#import "SWFUIModifiers.h"

@implementation SWFNewsDelegates

-(SWFNewsDelegates*) initWithWebView:(UIWebView*)newsWebView ViewController:(UIViewController*)vc getNews:(getNewsBlock)getNews name:(NSString*)name{
    self.delegateName = name;
    self.isFirstLoad = YES;
    self.isEmpty = YES;
    self.busy = NO;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.newsWebView = newsWebView;
    self.viewController = vc;
    self.getNews = getNews;
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.newsWebView.scrollView addSubview:self.refreshControl]; //<- this is point to use. Add "scrollView" property.
    [self.newsWebView loadHTMLString:@"<html><body></body></html>" baseURL:nil];
    self.newsWebView.delegate = self;
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"ui.cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ui.repost", @""),NSLocalizedString(@"ui.reply", @""),NSLocalizedString(@"ui.bookmark", @""),NSLocalizedString(@"ui.read-later", @""),NSLocalizedString(@"ui.reportAbuse", @""), nil];
    [self resetParameteres];
    self.newsWebView.dataDetectorTypes = UIDataDetectorTypeLink;
    for (UIView *view in [[newsWebView subviews][0] subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) view.hidden = YES;
    }
    
    newsWebView.backgroundColor = [[UIColor alloc] initWithRed:211 /255.0 green:211 / 255.0 blue:211 / 255.0 alpha:1.0];
    [newsWebView setOpaque:NO];
    return self;
}

- (void)manualBottomInsets{
    [SWFUIModifiers manualBottomTabBarInsetsFor:self.newsWebView.scrollView];

}

- (void)displayAd:(UIWebView*)webView{
//    if(self.adDelegates){
//        return;
//    }
//    self.adDelegates = [[SWFADBannerDelagates alloc] initWithRootViewController:self.viewController View:webView.scrollView];
//    __block SWFNewsDelegates *this = self;
//    self.adDelegates.AdLoaded = ^{
//        [this.newsWebView stringByEvaluatingJavaScriptFromString:@"reserveForAd(50)"];
//    };
//    self.adDelegates.AdFailed = ^{
//        [this.newsWebView stringByEvaluatingJavaScriptFromString:@"reserveForAd(0)"];
//    };
}

- (void)resetParameteres{
    self.toTail = NO;
    self.currentPage = 0;
    self.latestNewsDate = [NSDate distantPast];
    self.pageLastNewsDate = [NSDate distantPast];
}

- (void)loadNews{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    if (self.busy || self.toTail) {
        [self.refreshControl endRefreshing];
        return;
    }else{
        self.busy = YES;
    }
    if(self.isEmpty){
        [self.newsWebView.scrollView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
        [self.refreshControl beginRefreshing];
    }
    if(self.currentPage!=0){
        [self.newsWebView stringByEvaluatingJavaScriptFromString:@"loading()"];
    }
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *newsResponse = self.getNews();
        if(![newsResponse isKindOfClass:[NSArray class]]){
            self.busy = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
                [self.newsWebView stringByEvaluatingJavaScriptFromString:@"stopLoading()"];
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if([newsResponse count] > 0){
                SWFNews *lastNews = [newsResponse lastObject];
                self.pageLastNewsDate = lastNews.publishTime;
                self.latestNewsDate = [[newsResponse firstObject] publishTime];
                if (newsResponse.count <= 0) {
                    self.toTail = YES;
                }
                if(self.currentPage==0){
                    self.isEmpty = NO;
                    NSString *newsHTML = [SWFCodeGenerator generateForNewsArray:newsResponse];
                    if (![newsHTML isEqualToString:self.cachedContent]){
                        [self.newsWebView loadHTMLString:newsHTML baseURL:baseURL];
                        [self.adDelegates refreshAd];
                        if (_delegateName != nil){
                            [SWFCachePolicy cacheInWithData:newsResponse fileName:_delegateName];
                        }
                    } else {
                        [self.refreshControl endRefreshing];
                        [self.newsWebView stringByEvaluatingJavaScriptFromString:@"stopLoading()"];
                    }
                    self.cachedContent = nil;
                }else{
                    NSMutableString *items = [NSMutableString stringWithString:@""];
                    for (SWFNews *newsItem in newsResponse)
                    {
                        [items appendString:[SWFCodeGenerator generateForNews:newsItem level:0]];

                    }
                    NSString *tempPath = NSTemporaryDirectory();
                    NSString *path = [tempPath stringByAppendingPathComponent:@"dispNews.txt"];
                    NSError *err;
                    [items writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
                    [self.newsWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"append('%@')",path]];
                }
            } else {
                [self.newsWebView loadHTMLString:[NSString stringWithFormat:@"<center>%@</center>",NSLocalizedString(@"ui.news.nothing", nil)] baseURL:baseURL];
            }
        });
        self.busy = NO;
    });
    if (_isFirstLoad){
        if (_delegateName != nil){
            NSArray *cachedNews = [SWFCachePolicy cacheOutWithFileName:_delegateName];
            if (cachedNews != nil){
                NSString *cachedNewsHTML = [SWFCodeGenerator generateForNewsArray:cachedNews];
                if (cachedNewsHTML != nil){
                    [self.newsWebView loadHTMLString:cachedNewsHTML baseURL:baseURL];
                    self.cachedContent = cachedNewsHTML;
                }
                self.pageLastNewsDate = [[cachedNews lastObject] publishTime];
            }
        }
        _isFirstLoad = NO;
    }
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
    [self resetParameteres];
    [self loadNews];
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if([requestString hasPrefix:@"file://"] || [requestString hasPrefix:@"about:"]){
        return YES;
    } else if ([components count] > 1 && [(NSString *) components[0] isEqualToString:@"swf"]) {
        if([(NSString *) components[1] isEqualToString:@"nextpage"])
        {
            if(!self.busy){
                self.currentPage++;
                [self loadNews];
            }
        }else if ([(NSString *) components[1] isEqualToString:@"action"]){
            self.activeNewsId = (NSString *) components[2];
            [self.actionSheet showInView:self.viewController.view];
        }else if ([(NSString *) components[1] isEqualToString:@"repost"]){
            self.activeNewsId = (NSString *) components[2];
            [self presentInputAction:0 Id:self.activeNewsId];
        }else if ([(NSString *) components[1] isEqualToString:@"reply"]){
            self.activeNewsId = (NSString *) components[2];
            [self presentInputAction:1 Id:self.activeNewsId];
        }else if ([(NSString *) components[1] isEqualToString:@"bookmark"]){
            self.activeNewsId = (NSString *) components[2];
            [self presentInputAction:2 Id:self.activeNewsId];
        }else if ([(NSString *) components[1] isEqualToString:@"loaded"]){
            if(!self.busy && !self.isEmpty){
                if (self.loadCompleted != nil) {
                    self.loadCompleted();
                }
            }
            if (!self.isEmpty) {
                [self displayAd:self.newsWebView];
                if (self.adDelegates.isAdLoaded) {
                    [self.newsWebView stringByEvaluatingJavaScriptFromString:@"reserveForAd(50)"];
                }
            }
        }
    }else{
        if (navigationType == UIWebViewNavigationTypeLinkClicked) {
            SWFWebBrowserViewController *browser = [[SWFWebBrowserViewController alloc] initWithNibName:@"SWFWebBrowserViewController" bundle:nil];
            [self.viewController presentViewController:browser animated:YES completion:nil];
            [browser.webView loadRequest:request];
        }
    }
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.refreshControl endRefreshing];
}

- (void)presentInputAction:(int)action Id:(NSString*)newsId{
    SWFInputActionViewController *niavc = [[SWFInputActionViewController alloc] initWithNibName:@"SWFInputActionViewController" bundle:nil];
    niavc.action = action;
    niavc.newsId = newsId;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:niavc];
    [self.viewController presentViewController:nc animated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 4){
        SWFReportAbuseViewController *ravc;
        ravc = [[SWFReportAbuseViewController alloc] initWithRoot:[[QRootElement alloc] initWithJSONFile:@"reportAbuse"]];
        ravc.type = 0;
        ravc.obj = self.activeNewsId;
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:ravc];
        [self.viewController presentViewController:nvc animated:YES completion:nil];
    }
    if(buttonIndex != self.actionSheet.cancelButtonIndex){
        [self presentInputAction:buttonIndex Id:self.activeNewsId];
    }
}

@end
