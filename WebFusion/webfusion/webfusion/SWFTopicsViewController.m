//
//  SWFTopicsViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-2.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGICommon.h>
#import "SWFTopicsViewController.h"
#import "SWFPost.h"
#import "SWFGetPostListRequest.h"
#import "SWFUITopicCell.h"
#import "SWFPostDetailsViewController.h"
#import "SWFComposeTopicViewController.h"
#import "SWFPopNewPostsRequest.h"
#import "SWFCachePolicy.h"
#import "SWFNewThreadCountPoll.h"

@interface SWFTopicsViewController ()

@end

@implementation SWFTopicsViewController

@synthesize refreshControl;
@synthesize busy;
@synthesize isEmpty;
@synthesize currentPage;
@synthesize cells;
@synthesize topics;

static NSString *SWFTopicTableCellIdentifer = @"TopicCellTableIdentifier";
static NSString *SWFTableCellLoadingIdentifer = @"CellTableLoadingIdentifier";
static NSString *SWFUserTopicCacheFileName = @"userTopics";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[SWFPoll defaultPoll] addDelegate:self forKey:@"thc"];
        [[SWFPoll defaultPoll] repoll];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isFirstLoad = YES;
    self.busy = NO;
    self.isEmpty = YES;
    self.toTail = NO;
    self.currentPage = 0;
    self.title = NSLocalizedString(@"func.topics", @"");
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.cells = [NSMutableArray array];
    self.topics = [NSMutableArray array];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"SWFUITopicCell" bundle:nil] forCellReuseIdentifier:SWFTopicTableCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"SWFUILoadingCell" bundle:nil] forCellReuseIdentifier:SWFTableCellLoadingIdentifer];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self loadTopics];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super changeNavBarColor:[[UIColor alloc] initWithRed:0.0 green:84 / 255.0 blue:38 / 255.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        bool canSend = [[SWFAppDelegate getDefaultInstance] hasFeature:@"CanSend"];
        dispatch_async(dispatch_get_main_queue(),^{
            self.navigationItem.rightBarButtonItem.enabled = canSend;
        });
    });
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
    [self startTicker];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self stopTicker];
}

- (void) startTicker{
    [self.ticker invalidate];
    self.ticker = [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(tick:)
                                                 userInfo:nil
                                                  repeats:YES];
}

- (void)stopTicker{
    [self.ticker invalidate];
}

- (void)compose{
    SWFComposeTopicViewController *tvc = [[SWFComposeTopicViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
    [self refresh];
}

- (void) refresh{
    self.toTail = NO;
    currentPage = 0;
    [self loadTopics];
}

- (void)loadTopics{
    if (busy == YES) {
        [refreshControl endRefreshing];
        return;
    }else{
        busy = YES;
    }
    if (_isFirstLoad){
        NSArray *cachedTopics = [SWFCachePolicy cacheOutWithFileName:SWFUserTopicCacheFileName];
        if (cachedTopics != nil){
            [self loadTopicsToMemFrom:cachedTopics];
            [self.tableView reloadData];
        }
        _isFirstLoad = NO;
    }
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWFGetPostListRequest *r = [[SWFGetPostListRequest alloc] init];
        r.type = @"tjoined";
        r.page = currentPage;
        r.contact = @"";
        NSArray *topicsResponse = [r getPostList];
        if(![topicsResponse isKindOfClass:[NSArray class]]){
            [refreshControl endRefreshing];
            busy = NO;
            return;
        }
        if(currentPage==0){
            cells = [NSMutableArray array];
            topics = [NSMutableArray array];
            [[[SWFPopNewPostsRequest alloc] init] popNewPosts];
            [SWFCachePolicy cacheInWithData:topicsResponse fileName:SWFUserTopicCacheFileName];
            self.navigationController.tabBarItem.badgeValue = nil;
        }
        [self loadTopicsToMemFrom:topicsResponse];
        if ([topicsResponse count] < 20) {
            self.toTail = YES;
        }
        isEmpty = NO;
        busy = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [refreshControl endRefreshing];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        });
    });
}

- (void)loadTopicsToMemFrom:(NSArray *)news{
    for (SWFPost *p in news){
        [cells addObject:[[SWFTopicCellViewController alloc] initWithPost:p UIVC:self]];
        [topics addObject:p];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.toTail) {
        return [cells count];
    }
    return [cells count] + 1;
}

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.row < [topics count]);
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [topics count]) {
        SWFPost *post = topics[indexPath.row];
        SWFPostDetailsViewController *pvc = [[SWFPostDetailsViewController alloc] initWithNibName:@"SWFPostDetailsViewController" bundle:nil];
        pvc.post = post;
        [self.navigationController pushViewController:pvc animated:YES];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < [cells count]){
        SWFUITopicCell *cell = [tableView dequeueReusableCellWithIdentifier:SWFTopicTableCellIdentifer];
        [cell setCellViewController: cells[indexPath.row]];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SWFTableCellLoadingIdentifer];
         if(!isEmpty){
             currentPage ++;
             [self loadTopics];
         }
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [cells count]) {
        return 100.0;
    }else{
        return 60.0;
    }
}

- (void) tick:(NSTimer *) timer {
    if ([cells count]) {
        [self.tableView reloadData];
    }
}

- (id)poll:(SWFPoll *)poll objectForKey:(NSString *)key
{
    if(YES){
        SWFNewThreadCountPoll *poll = [[SWFNewThreadCountPoll alloc] init];
        poll.thvt = self.badgeNum;
        return poll;
    }else{
        return nil;
    }
}

- (void)poll:(SWFPoll *)poll receivedObject:(id)object forKey:(NSString *)key
{
    if ([object respondsToSelector:@selector(integerValue)])
    {
        int thc = [object integerValue];
        if(thc != self.badgeNum){
            self.badgeNum = thc;
            if(thc > 0){
                self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.badgeNum];
            }else{
                self.badgeNum = nil;
            }
        }
        [[SWFPoll defaultPoll] repoll];
    }
}

@end
