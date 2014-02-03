//
//  SWFAddContactViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-20.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFUserServices.h"
#import "SWFTrackedViewController.h"

@interface SWFAddContactViewController : SWFTrackedViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segButtons;

@property UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property UITextField *textAddress;
@property UITextField *textName;
@property (strong, nonatomic) IBOutlet UINavigationBar *naviBar;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)sourceSwitched:(id)sender;


@property NSArray *canSearchAddContactServices;
@property (atomic)NSMutableArray *searchedItems;
@property (atomic) NSString* currentSearch;
@property (atomic) int currentSource;

@property SWFUserServices *pickedUserService;

@property NSString *staticName;

-(void)staticName:(NSString*)name UITitle:(NSString*)title;

@end
