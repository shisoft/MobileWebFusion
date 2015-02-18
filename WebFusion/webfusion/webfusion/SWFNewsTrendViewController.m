//
//  SWFNewsTrendViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-27.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFNewsTrendViewController.h"
#import "SWFNewsTrendWrapper.h"
#import "SWFNewsTrendsRequest.h"
#import "SWFSearchNewsRequest.h"
#import "SWFNews.h"
#import "SWFWebBrowserViewController.h"
#import "SWFCodeGenerator.h"
#import "SWFWrapper.h"
#import "UIImage+SWFUtilities.h"
#import "SWFNewsDelegates.h"

@interface SWFNewsTrendViewController ()

@end

@implementation SWFNewsTrendViewController

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
    self.title = NSLocalizedString(@"func.trend", @"");
    [self.searchBar becomeFirstResponder];
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:
                                        NSLocalizedString(@"ui.trendDay", @""),
                                        NSLocalizedString(@"ui.trendWeek", @""),
                                        NSLocalizedString(@"ui.trendMonth", @""),
                                        NSLocalizedString(@"ui.trendYear", @""),
                                        nil];
    [self.searchBar setImage:[[UIImage imageNamed:@"trendIcon_tool"] maskedImageColor:[UIColor lightGrayColor]] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    for (UIView *searchBarSubview in [self.searchBar subviews]) {
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyGo];
            //[(UITextField *)searchBarSubview setKeyboardAppearance:UIKeyboardAppearanceAlert];
            // always force return key to be enabled
            [(UITextField *)searchBarSubview setEnablesReturnKeyAutomatically:NO];
        }
    }
    self.delegates = [[SWFNewsDelegates alloc] initWithWebView:self.webView ViewController:self getNews:^id{
        SWFSearchNewsRequest *snr = [[SWFSearchNewsRequest alloc] init];
        snr.kw = self.kw;
        snr.page = self.delegates.currentPage;
        snr.publish = [NSString stringWithFormat:@"[%lld TO %lld]",[self getTimeStart], [self getTimeEnd]];
        return [snr searchNews];
    }];
    __block SWFNewsTrendViewController *this = self;
    self.delegates.loadCompleted = ^(void){
        [this.searchBar resignFirstResponder];
        if ([this.kw length] <= 0) {
            return;
        }
        dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            SWFNewsTrendsRequest *nt = [[SWFNewsTrendsRequest alloc] init];
            nt.queries = [NSArray arrayWithObjects:[NSArray arrayWithObjects:this.kw, nil], nil];
            nt.ita = [this getIta];
            nt.pubEnd = [this getTimeEnd];
            nt.pubStart = [this getTimeStart];
            SWFWrapper *w = [nt newsTrends];
            if ([w isKindOfClass:[SWFWrapper class]]) {
                NSString *data = [nt stringForDownlinkData];
                NSString *tempPath = NSTemporaryDirectory();
                NSString *path = [tempPath stringByAppendingPathComponent:@"trendGraphData.txt"];
                NSError *err;
                [data writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [this.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"plotTrend('%@')",path]];
                });
            }
        });
    };
    [self.delegates manualBottomInsets];
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
    [self reloadNews];
}

-(void)reloadNews{
    [self.delegates resetParameteres];
    [self.delegates loadNews];
}

-(long long)getTimeStart{
    long long now = [self getCurrentTimestamp];
    switch (self.searchBar.selectedScopeButtonIndex) {
        case 0:
            return now - (1000 * 60 * 60 * 24);
            break;
        case 1:
            return now - (1000 * 60 * 60 * 24 * 7);
            break;
        case 2:
            return now - (1000 * 60 * 60 * 24 * 31);
            break;
        case 3:
            return now - (1000 * 60 * 60 * 24 * 365);
            break;
        default:
            return -1;
            break;
    }
}

-(int)getIta{
    switch (self.searchBar.selectedScopeButtonIndex) {
        case 0:
            return 24;
            break;
        case 1:
            return 7;
            break;
        case 2:
            return 30;
            break;
        case 3:
            return 12;
            break;
        default:
            return -1;
            break;
    }
}

-(long long)getTimeEnd{
    return [self getCurrentTimestamp];
}

-(long long)getCurrentTimestamp{
    NSDate *now = [NSDate date];
    NSTimeInterval interval = [now timeIntervalSince1970];
    long long intervalNum = (long) interval;
    long long m = 1000;
    long long r = intervalNum * m;
    return r;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self startTrend];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self startTrend];
}

- (void)startTrend{
    if ([self.searchBar.text length] <= 0) {
        return;
    }
    self.kw = [[NSString alloc] initWithFormat:@"\"%@\"",self.searchBar.text];
    [self reloadNews];
}

@end
