//
//  SWFUserContactPickerViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-21.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFTrackedViewController.h"

typedef void(^callbackBlock)(id);

@interface SWFUserContactPickerViewController : SWFTrackedViewController

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

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;
@property (strong, nonatomic) IBOutlet UINavigationItem *titleBar;

@property int source; // 0: general 1:online
@property NSArray *exceptions;

- (IBAction)cancelButtonPressed:(id)sender;

- (void) loadContactsFromSource:(int)source exceptionIDs:(NSArray*)exceptsions callback:(callbackBlock)_callback title:(NSString*)title;

@end
