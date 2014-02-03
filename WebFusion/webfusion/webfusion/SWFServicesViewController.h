//
//  SWFServicesViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-23.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFTrackedViewController.h"

@interface SWFServicesViewController : SWFTrackedViewController <UITableViewDataSource, UITableViewDelegate>

@property NSArray *userServices;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)loadServicesAsync;
-(void)dismissNav;

@end
