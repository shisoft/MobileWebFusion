//
//  SWFTopicsViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-2.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CGIJSONObject/CGICommon.h>
#import "SWFNavedCenterViewController.h"



@interface SWFTopicsViewController : SWFNavedCenterViewController <UITableViewDelegate, UITableViewDataSource>

@property UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property BOOL busy;
@property BOOL isEmpty;
@property int currentPage;
@property NSMutableArray *cells;
@property NSMutableArray *topics;
@property BOOL toTail;
@property NSTimer *ticker;

@property BOOL isFirstLoad;
@property NSString *cachedFile;

- (void) refresh;

@end
