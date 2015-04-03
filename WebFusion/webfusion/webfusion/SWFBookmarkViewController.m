//
//  SWFBookmarkViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-25.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGICommon.h>
#import "SWFBookmarkViewController.h"
#import "SWFGetUserBookmarksRequest.h"
#import "SWFBookmarkWrapper.h"
#import "SWFBookmarkCell.h"
#import "NSString+SWFUtilities.h"
#import "SWFSingleNewsViewController.h"
#import "SWFPostDetailsViewController.h"
#import "SWFDeleteBookmarkRequest.h"
#import "SWFCachePolicy.h"

@interface SWFBookmarkViewController ()

@end

@implementation SWFBookmarkViewController {
    NSMutableArray *_bookmarks;
}

static NSString *SWFBookmarkCellTableIdentifier = @"BookmarkCellTableIdentifier";
static NSString *SWFTableCellLoadingIdentifer = @"CellTableLoadingIdentifier";

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
    self.title = NSLocalizedString(@"func.favourites", @"");
    self.busy = NO;
    self.isEmpty = YES;
    self.currentPage = 0;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl]; //<- this is point to use. Add "scrollView" property.
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"SWFBookmarkCell" bundle:nil] forCellReuseIdentifier:SWFBookmarkCellTableIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SWFUILoadingCell" bundle:nil] forCellReuseIdentifier:SWFTableCellLoadingIdentifer];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ui.edit", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(edit)];
    [self loadBookmarks];
    [super changeNavBarColor:[[UIColor alloc] initWithRed:(CGFloat) (193 / 255.0) green:(CGFloat) (32 / 255.0) blue:(CGFloat) (81 / 255.0) alpha:1.0]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
}

- (void)edit{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing) {
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"ui.done", @"");
    } else {
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleBordered];
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"ui.edit", @"");
    }
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
    self.currentPage = 0;
    self.toTail = NO;
    [self loadBookmarks];
}

- (void) addCellsByArray:(NSArray *)list{
    for (SWFBookmarkWrapper *bw in list) {
        [self.bookmarks addObject:bw];
        [self.cells addObject:[[SWFBookmarkCellViewController alloc] initWithBookmarkWrapper:bw]];
    }
}

- (void)loadBookmarks{
    if (self.busy) {
        [self.refreshControl endRefreshing];
        return;
    }else{
        self.busy = YES;
    }
    NSString *cacheName = @"bookmarks";
    if(self.currentPage==0){
        NSArray *cache = (id) [SWFCachePolicy cacheOutWithFileName:cacheName];
        self.bookmarks = [NSMutableArray array];
        self.cells = [NSMutableArray array];
        if (cache){
            [self addCellsByArray:cache];
        }
        //[SWFCachePolicy cacheInWithData:newsResponse fileName:cacheName];
    }
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWFGetUserBookmarksRequest *r = [[SWFGetUserBookmarksRequest alloc] init];
        r.page = self.currentPage;
        NSArray *bookmarksResponse = [r getUserBookmarks];
        if(![bookmarksResponse isKindOfClass:[NSArray class]]){
            return;
            self.busy = NO;
        }
        if (self.currentPage==0){
            self.bookmarks = [NSMutableArray arrayWithCapacity:[bookmarksResponse count]];
            self.cells = [NSMutableArray arrayWithCapacity:[bookmarksResponse count]];
            [SWFCachePolicy cacheInWithData:(id) bookmarksResponse fileName:cacheName];
        }
        [self addCellsByArray:bookmarksResponse];
        if ([bookmarksResponse count] < 20) {
            self.toTail = YES;
        }
        self.isEmpty = NO;
        self.busy = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    });
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.toTail) {
        return [self.bookmarks count];
    }
    return [self.bookmarks count] + 1;
}

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.row < [self.bookmarks count]);
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [self.bookmarks count]) {
        SWFBookmarkWrapper *bw = [self.bookmarks objectAtIndex:indexPath.row];
        switch (bw.bm.type) {
            case 0:
            {
                SWFNews *news = [bw newsValue];
                SWFSingleNewsViewController *snvc = [[SWFSingleNewsViewController alloc] initWithNibName:@"SWFSingleNewsViewController" bundle:nil];                snvc.title = [news.title stringByStrippingHTML];
                snvc.news = news;
                [self.navigationController pushViewController:snvc animated:YES];
            }
                break;
            case 1:
            {
                SWFPost *post = [bw postValue];
                SWFPostDetailsViewController *pdvc = [[SWFPostDetailsViewController alloc] initWithNibName:@"SWFPostDetailsViewController" bundle:nil];
                pdvc.post = post;
                [self.navigationController pushViewController:pdvc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < [self.bookmarks count]){
        SWFBookmarkCell *cell = [tableView dequeueReusableCellWithIdentifier:SWFBookmarkCellTableIdentifier];
        SWFBookmarkCellViewController *bcvc = self.cells[(NSUInteger) indexPath.row];
        [bcvc displayInCell:cell];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SWFTableCellLoadingIdentifer];
        if(!self.isEmpty){
            self.currentPage ++;
            [self loadBookmarks];
        }
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [self.bookmarks count]) {
        return 100.0;
    }else{
        return 60.0;
    }
}

- (BOOL) tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {    
    SWFBookmarkWrapper *bw = self.bookmarks[(NSUInteger) indexPath.row];
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            SWFDeleteBookmarkRequest *dbr = [[SWFDeleteBookmarkRequest alloc] init];
            dbr.ID = bw.bm.ID;
            [dbr deleteBookmark];
            [self.bookmarks removeObject:bw];
            [self.cells removeObjectAtIndex:(NSUInteger) indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
            });
        });
    }
}

@end
