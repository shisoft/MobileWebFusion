//
//  SWFBookmarkViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-25.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFNavedCenterViewController.h"

@interface SWFBookmarkViewController : SWFNavedCenterViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property UIRefreshControl *refreshControl;
@property NSMutableArray *bookmarks;
@property NSMutableArray *cells;
@property BOOL busy;
@property BOOL isEmpty;
@property int currentPage;
@property BOOL toTail;
@property NSTimer *ticker;
- (void) refresh;

@end
