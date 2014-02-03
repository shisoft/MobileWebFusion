//
//  SWFFeaturedUserServicePickerViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-21.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFFeaturedUserServicePickerViewController.h"
#import "SWFGetFeaturedUserServicesRequest.h"
#import "SWFAvatarHelper.h"
#import "SWFUserServices.h"

@interface SWFFeaturedUserServicePickerViewController ()

@end

@implementation SWFFeaturedUserServicePickerViewController

callbackBlock callback;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)getFeaturedUserSerive:(NSString*)feature title:(NSString*)title callback:(callbackBlock)_callback{
    callback = _callback;
    self.title = title;
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWFGetFeaturedUserServicesRequest *r = [[SWFGetFeaturedUserServicesRequest alloc] init];
        r.feature = feature;
        self.userServices = [r getFeaturedUserServices];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    // Do any additional setup after loading the view from its nib.
}

- (void) cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.userServices count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *serviceItemIditifer = @"serviceItemIditifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:serviceItemIditifer];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:serviceItemIditifer];
    }
    SWFUserServices *us = [self.userServices objectAtIndex:indexPath.row];
    NSString *svrExpLocalizeKey = [NSString stringWithFormat:@"svr.%@",us.gate];
    cell.textLabel.text = us.account;
    cell.detailTextLabel.text = NSLocalizedString(svrExpLocalizeKey, @"");
    cell.imageView.image = [UIImage imageNamed:us.gate];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    callback([self.userServices objectAtIndex:indexPath.row]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
