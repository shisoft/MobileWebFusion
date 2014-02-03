//
//  SWFServicesViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-23.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFServicesViewController.h"
#import "SWFGetUserServicesRequest.h"
#import "SWFUserServices.h"
#import "SWFAddServiceViewController.h"
#import "SWFLoadingHUD.h"
#import "SWFDeleteUserServiceRequest.h"
#import "UIActionSheet+MKBlockAdditions.h"
#import "UIAlertView+MKBlockAdditions.h"

@interface SWFServicesViewController ()

@end

@implementation SWFServicesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"ui.services", @"");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addService)];
    // Do any additional setup after loading the view from its nib.
}

- (void)addService{
    SWFAddServiceViewController *asvc = [[SWFAddServiceViewController alloc] initWithNibName:@"SWFAddServiceViewController" bundle:nil];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:asvc];
    [self presentViewController:nv animated:YES completion:nil];
    asvc.userServiceListView = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadServicesSync];
}

- (void)loadServicesSync{
    SWFLoadingHUD *lhud = [[SWFLoadingHUD alloc] initWithBody:nil];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self loadServices];
        dispatch_async(dispatch_get_main_queue(),^{
            [self.tableView reloadData];
            [lhud dismiss];
        });
    });
}

- (void)loadServicesAsync{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self loadServices];
        dispatch_async(dispatch_get_main_queue(),^{
            [self.tableView reloadData];
        });
    });
}

- (void)loadServices{
    SWFGetUserServicesRequest *r = [[SWFGetUserServicesRequest alloc] init];
    self.userServices = [r getUserServices];
    if(![self.userServices isKindOfClass:[NSArray class]]){
        self.userServices = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.userServices count]){
        return [self.userServices count];
    }else if( self.userServices != nil ){
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.userServices count]) {
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
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"needAdd"];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = NSLocalizedString(@"ui.needAddService", @"");
        return cell;
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.userServices count] != 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [UIActionSheet actionSheetWithTitle:nil message:nil destructiveButtonTitle:NSLocalizedString(@"ui.delete", @"") buttons:nil showInView:self.view onDismiss:^(int buttonIndex) {
        [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.deleteService", @"") cancelButtonTitle:NSLocalizedString(@"ui.cancel", @"") otherButtonTitles:[[NSArray alloc] initWithObjects:NSLocalizedString(@"ui.ok", @""), nil] onDismiss:^(int buttonIndex) {
            dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                SWFLoadingHUD *lhud = [[SWFLoadingHUD alloc] initWithBody:nil];
                SWFDeleteUserServiceRequest *dusr = [[SWFDeleteUserServiceRequest alloc] init];
                dusr.ID = ((SWFUserServices *)[self.userServices objectAtIndex:indexPath.row]).ID;
                [dusr deleteUserService];
                dispatch_async(dispatch_get_main_queue(),^{
                    [lhud dismiss];
                    [self loadServicesSync];
                });
            });
        } onCancel:^{
            
        }];
    } onCancel:^{
        
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)dismissNav{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{[SWFAppDelegate initializePNS];}];
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}

@end
