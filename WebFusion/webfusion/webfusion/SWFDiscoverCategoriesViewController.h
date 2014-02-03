//
//  SWFDiscoverCategoriesViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-26.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFDiscoverViewController.h"
#import "SWFTrackedViewController.h"

@interface SWFDiscoverCategoriesViewController : SWFTrackedViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *categories;
@property NSDictionary *categoriesMap;
@property NSMutableArray *userTopDist;
@property NSMutableArray *userSelectedTopics;
@property SWFDiscoverViewController *dvc;
@property BOOL needCopy;

- (void)link:(SWFDiscoverViewController*)dvc;

@end
