//
//  SWFContactsViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-16.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFNavedCenterViewController.h"

@interface SWFContactsViewController : SWFNavedCenterViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property UIRefreshControl *refreshControl;

@property BOOL busy;
@property BOOL isEmpty;
@property BOOL isSearchEmpty;
@property int currentPage;
@property int currentSearchedPage;
@property NSMutableArray *contacts;
@property NSMutableArray *searchedContacts;
@property NSString *currentSearchQuery;
@property BOOL searchToTail;
@property BOOL contactToTail;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;

@end
