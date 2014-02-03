//
//  SWFContactDetailsViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-18.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFUserContact.h"
#import "SWFTrackedViewController.h"

@interface SWFContactDetailsViewController : SWFTrackedViewController
<UITableViewDataSource, UITableViewDelegate>

@property NSArray *contactMethods;
@property SWFUserContact *userContact;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property UIImageView *avatarView;
@property UIImage *avatarImage;

- (void)loadUserContact : (SWFUserContact*) uc;

- (IBAction)addButtonPressed:(id)sender;
- (IBAction)combineButtonPressed:(id)sender;
- (IBAction)renameButtonPressed:(id)sender;
- (IBAction)removeButtonPressed:(id)sender;

@end
