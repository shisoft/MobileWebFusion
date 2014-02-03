//
//  SWFAddContactViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-20.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFAddContactViewController.h"
#import "SWFSearchRequest.h"
#import "SWFGetFeaturedUserServicesRequest.h"
#import "SWFNews.h"
#import "SWFUniversalContact.h"
#import "SWFUserServices.h"
#import "SWFAvatarHelper.h"
#import "SWFNewContactByUCIDRequest.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "SWFWrapper.h"
#import "SWFFeaturedUserServicePickerViewController.h"
#import "SWFNewContactRequest.h"

@interface SWFAddContactViewController ()

@end

@implementation SWFAddContactViewController

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
    self.navItem.prompt = NSLocalizedString(@"ui.addContactPrompt", @"");
    self.segButtons.selectedSegmentIndex = 0;
    [self.segButtons setTitle:NSLocalizedString(@"ui.searchAddContact", @"") forSegmentAtIndex:0];
    [self.segButtons setTitle:NSLocalizedString(@"ui.inputAddContact", @"") forSegmentAtIndex:1];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,70,320,44)];
    self.searchBar.delegate = self;
    [self loadTable];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.naviBar setFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self.naviBar.frame.size.width, self.naviBar.frame.size.height)];
        [self.tableView setFrame:CGRectMake(0, self.naviBar.frame.origin.y + self.naviBar.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height - (self.naviBar.frame.origin.y))];
    } else {
        // OS version < 7.0
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)staticName:(NSString*)name UITitle:(NSString*)title{
    self.staticName = name;
    self.navItem.prompt = title;
}

- (void)loadTable{
    [self.tableView reloadData];
    switch (self.segButtons.selectedSegmentIndex) {
        case 0:
            [self.tableView setTableHeaderView:self.searchBar];
            if ([self.searchedItems count] <= 0) {
                [self.searchBar becomeFirstResponder];
            }
            break;
        case 1:
        {
            [self.tableView setTableHeaderView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.textAddress becomeFirstResponder];
            });
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    if (self.currentSource == 1) {
        if (self.pickedUserService == nil || [self.textAddress.text length] < 1 || [self.textName.text length] < 1) {
            [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.emptyInput", @"") cancelButtonTitle:NSLocalizedString(@"ui.ok", @"")];
            return;
        }
        dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            SWFNewContactRequest *r = [[SWFNewContactRequest alloc] init];
            r.svr = self.pickedUserService.ID;
            r.address = self.textAddress.text;
            r.displayName = self.textName.text;
            SWFWrapper * w = [r newContact];
            if ([w isKindOfClass:[SWFWrapper class]]) {                
                if ([[w stringValue] length] > 1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                    return;
                }
            }
            [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.cannotAddContact", @"") cancelButtonTitle:NSLocalizedString(@"ui.ok", @"")];
            return;
        });
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sourceSwitched:(id)sender {
    self.currentSource = self.segButtons.selectedSegmentIndex;
    [self loadTable];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    switch (self.segButtons.selectedSegmentIndex) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.currentSource) {
        case 0:
            return self.searchedItems.count;
            break;
        case 1:
            return 3;
            break;
        default:
            return 0;
            break;
    }

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *contactItemIditifer = @"contactItemIditifer";
    static NSString *selServiceIdentifier = @"selServiceIdentifier";
    static NSString *addressIdentifier = @"addressIdentifier";
    static NSString *nameIdentifier = @"nameIdentifier";
    UITableViewCell *cell;
    switch (self.currentSource) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:contactItemIditifer];
            if (cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:contactItemIditifer];
            }
            SWFNews *sr = [self.searchedItems objectAtIndex:indexPath.row];
            cell.textLabel.text = sr.authorUC.dispName;
            //if ([sr.additionalClue isKindOfClass:[NSDictionary class]]) {
            //    NSMutableString *clues = [[NSMutableString alloc] init];
            //    for (NSString *key in [sr.additionalClue allKeys]) {
            //        [clues appendFormat:@"%@ ",[sr.additionalClue objectForKey:key]];
            //    }
            //    cell.detailTextLabel.text = clues;
            //}
            if ([sr.content isKindOfClass:[NSString class]]) {
                cell.detailTextLabel.text = sr.content;
            }
            cell.tag = indexPath.row;
            cell.imageView.image = [SWFAvatarHelper displayAvatar:sr.authorUC.avatar callback:^(id img){
                if (cell.tag == indexPath.row) {
                    cell.imageView.image = img;
                }
            } roundCorner:NO];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:selServiceIdentifier];
                    if (cell == nil){
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selServiceIdentifier];
                        cell.textLabel.text = NSLocalizedString(@"ui.selServiceForAddContact", @"");
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                    if (self.pickedUserService != nil) {
                        SWFUserServices *us = self.pickedUserService;
                        NSString *svrExpLocalizeKey = [NSString stringWithFormat:@"svr.%@",us.gate];
                        cell.textLabel.text = us.account;
                        cell.detailTextLabel.text = NSLocalizedString(svrExpLocalizeKey, @"");
                        cell.imageView.image = [UIImage imageNamed:us.gate];
                    }
                }
                    break;
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:addressIdentifier];
                    if (cell == nil){
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addressIdentifier];
                        self.textAddress = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 21)];
                        self.textAddress.adjustsFontSizeToFitWidth = YES;
                        self.textAddress.placeholder = NSLocalizedString(@"ui.inputAddressForContact", @"");
                        self.textAddress.keyboardType = UIKeyboardTypeEmailAddress;
                        self.textAddress.textAlignment = NSTextAlignmentLeft;
                        self.textAddress.returnKeyType = UIReturnKeyNext;
                        self.textAddress.delegate = self;
                        [cell.contentView addSubview:self.textAddress];
                    }
                    [self.textAddress becomeFirstResponder];
                }
                    break;
                case 2:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:nameIdentifier];
                    if (cell == nil){
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nameIdentifier];
                        self.textName = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 21)];
                        self.textName.adjustsFontSizeToFitWidth = YES;
                        self.textName.placeholder = NSLocalizedString(@"ui.inputNameForContact", @"");
                        self.textName.textAlignment = NSTextAlignmentLeft;
                        self.textName.returnKeyType = UIReturnKeyDone;
                        self.textName.delegate = self;
                        if(self.staticName!=nil){
                            self.textName.enabled = NO;
                            self.textName.text = self.staticName;
                        }
                        [cell.contentView addSubview:self.textName];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.currentSource == 0 || (self.currentSource == 1 && indexPath.row == 0);
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.currentSource) {
        case 0:
        {
            SWFNews *sr = [self.searchedItems objectAtIndex:indexPath.row];
            if ([self.staticName length] > 0) {
                [self addSearchedContactByName:self.staticName sr:sr];
            }else{
                __block UIAlertView *alert = [UIAlertView initAlertViewWithTitle:NSLocalizedString(@"ui.setNameForContact", @"") message:NSLocalizedString(@"ui.setNameForContactDesc", @"") cancelButtonTitle:NSLocalizedString(@"ui.cancel", @"") otherButtonTitles:[[NSArray alloc] initWithObjects:NSLocalizedString(@"ui.ok", @""), nil] onDismiss:^(int buttonIndex) {
                    NSString *name = [alert textFieldAtIndex:0].text;
                    [self addSearchedContactByName:name sr:sr];
                } onCancel:^{
                    
                }];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert show];
                [alert textFieldAtIndex:0].text = sr.authorUC.dispName;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    SWFFeaturedUserServicePickerViewController *picker = [[SWFFeaturedUserServicePickerViewController alloc] initWithNibName:@"SWFFeaturedUserServicePickerViewController" bundle:nil];
                    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:picker];
                    [self presentViewController:nc animated:YES completion:^{
                    }];
                    [picker getFeaturedUserSerive:@"CanAddContact" title:NSLocalizedString(@"ui.selServiceForAddContact", @"") callback:^(id svr) {
                        self.pickedUserService = svr;
                        [self.tableView reloadData];
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
    }
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)addSearchedContactByName: (NSString*)name sr:(SWFNews*)sr{
    if ([name length] <= 0) {
        return;
    }
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWFUserServices *svr = sr.tag;
        SWFNewContactByUCIDRequest *r = [[SWFNewContactByUCIDRequest alloc] init];
        r.svr = svr.ID;
        r.ucid = sr.authorUC.ID;
        r.displayName = name;
        NSString *response = [[r newContactByUCID] stringValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([response length] > 1) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else if ([response isEqualToString:@"*"]) {
                [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.contactExists", @"") cancelButtonTitle:NSLocalizedString(@"ui.ok", @"")];
            } else if ([response isEqualToString:@"-"]) {
                [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.cannotAddContact", @"") cancelButtonTitle:NSLocalizedString(@"ui.ok", @"")];
            }
        });
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.textAddress isFirstResponder]) {
        [self.textName becomeFirstResponder];
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchedItems = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    NSString *query = searchBar.text;
    self.currentSearch = query;
    [self.searchBar resignFirstResponder];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([self.canSearchAddContactServices count] < 1){
            SWFGetFeaturedUserServicesRequest *fr = [[SWFGetFeaturedUserServicesRequest alloc] init];
            fr.feature = @"CanSearchAddContact";
            self.canSearchAddContactServices = [fr getFeaturedUserServices];
        }
        for (SWFUserServices *svr in self.canSearchAddContactServices){
            dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (!([query isEqualToString:self.currentSearch] && self.currentSource == 0)) {
                    return;
                }
                SWFSearchRequest * r = [[SWFSearchRequest alloc] init];
                r.kw = query;
                r.svr = [NSString stringWithFormat:@"%@:%@",svr.gate,svr.account];
                r.types = @"user";
                NSArray *rArr = [r search];
                if (![rArr isKindOfClass:[NSArray class]]){
                    return;
                }
                for (SWFNews *nr in rArr){
                    if ([r.kw isEqualToString:self.currentSearch] && self.segButtons.selectedSegmentIndex == 0) {
                        nr.tag = svr;
                        [self.searchedItems addObject:nr];
                    }else{
                        return;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
        }
    });
}

@end
