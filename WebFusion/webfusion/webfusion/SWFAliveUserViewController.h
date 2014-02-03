//
//  SWFAliveUserViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-10-28.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFPoll.h"

@interface SWFAliveUserViewController : UITableViewController <UISearchBarDelegate, SWFPollDelegate>

@property UISearchBar *searchBar;
@property UIRefreshControl *refreshControl;

@property BOOL isInForeground;
@property BOOL needRefresh;

@property NSArray *aliveContacts;
@property NSArray *searchResult;

@property int pollResult;

- (void)loadAlive;

@end
