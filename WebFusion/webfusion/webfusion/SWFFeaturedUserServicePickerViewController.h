//
//  SWFFeaturedUserServicePickerViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-21.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFTrackedViewController.h"

typedef void(^callbackBlock)(id);

@interface SWFFeaturedUserServicePickerViewController : SWFTrackedViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *userServices;

- (void)getFeaturedUserSerive:(NSString*)feature title:(NSString*)title callback:(callbackBlock)_callback;

@end
