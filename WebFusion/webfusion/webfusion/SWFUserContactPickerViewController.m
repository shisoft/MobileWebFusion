//
//  SWFUserContactPickerViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-21.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFUserContactPickerViewController.h"
#import "SWFUserContact.h"
#import "SWFAvatarHelper.h"
#import "SWFUniversalContact.h"
#import "UIImage+SWFUtilities.h"
#import "SWFGetContactDetailsRequest.h"
#import "SWFUserContactMethod.h"
#import "SWFUserContactGroup.h"
#import "SWFUserContactDetails.h"
#import "SWFWrapper.h"
#import "SWFUpdateUserContactMethodOrderRequest.h"
#import "SWFDeleteContactFromIDRequest.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "SWFAddContactViewController.h"
#import "SWFUserContactRequest.h"
#import "SWFGetContactsForPostRequest.h"
#import "SWFGetContactSuggestionsRequest.h"

@interface SWFUserContactPickerViewController ()

@end

@implementation SWFUserContactPickerViewController

callbackBlock callback;

static NSString *SWFTableCellLoadingIdentifer = @"CellTableLoadingIdentifier";
static int SWFDefaultContactCount = 30;

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
    self.busy = NO;
    self.isEmpty = YES;
    self.isSearchEmpty = YES;
    self.searchToTail = NO;
    self.contactToTail = NO;
    self.currentPage = 0;
    self.refreshControl = [[UIRefreshControl alloc] init];
    if (![self.title length]) {
        self.title = NSLocalizedString(@"func.contacts", @"");
    }
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl]; //<- this is point to use. Add "scrollView" property.
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"SWFUILoadingCell" bundle:nil] forCellReuseIdentifier:SWFTableCellLoadingIdentifer];
    [self.tableView setTableHeaderView:self.searchBar];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    // Do any additional setup after loading the view from its nib.
}

- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loadContactsFromSource:(int)source exceptionIDs:(NSArray*)exceptsions callback:(callbackBlock)_callback title:(NSString*)title{
    self.source = source;
    self.exceptions = exceptsions;
    self.title = title;
    callback = _callback;
    [self loadContacts:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)handleRefresh:(UIRefreshControl *)refresh {
    [self refresh];
}

- (void) refresh{
    self.currentPage = 0;
    self.contactToTail = NO;
    [self loadContacts:nil];
}

- (void) loadContacts : (NSString*) query{
    if (self.busy == YES) {
        [self.refreshControl endRefreshing];
        return;
    }else{
        self.busy = YES;
    }
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *contactResponse;
        switch (self.source) {
            case 0:
            {
                SWFUserContactRequest *r = [[SWFUserContactRequest alloc] init];
                r.query = @"";
                r.group = @"";
                r.page = self.currentPage;
                if ([query length] > 0){
                    r.query = query;
                    r.page = self.currentSearchedPage;
                }
                contactResponse = [r getContactNames];
            }
                break;
            case 1:
            {
                if ([query length] > 0){
                    SWFGetContactSuggestionsRequest *r = [[SWFGetContactSuggestionsRequest alloc] init];
                    r.key = query;
                    contactResponse = [r getContactSuggestions];
                }else{                    
                    SWFGetContactsForPostRequest *r = [[SWFGetContactsForPostRequest alloc] init];
                    contactResponse = [r getContactsForPost];
                }
            }
                break;
            default:
                break;
        }
        
        
        if(![contactResponse isKindOfClass:[NSArray class]]){
            return;
            self.busy = NO;
        }
        
        if([self.exceptions isKindOfClass:[NSArray class]]?[self.exceptions count] > 0:NO){
            NSMutableArray *eArr = [[NSMutableArray alloc] init];
            for (SWFUserContact *uc in contactResponse){
                BOOL excepted = NO;
                for (SWFUserContact * euc in self.exceptions) {
                    NSString *id1 = euc.ID;
                    NSString *id2 = uc.ID;
                    if ([id1 isEqualToString:id2]) {
                        excepted = YES;
                        break;
                    }
                }
                if (!excepted) {                    
                    [eArr addObject:uc];
                }
            }
            contactResponse = eArr;
        }
        
        if ([query length] > 0){
            if(self.currentSearchedPage==0){
                self.searchedContacts = [NSMutableArray arrayWithCapacity:[contactResponse count]];
            }
            for (SWFUserContact *uc in contactResponse){
                [self.searchedContacts addObject:uc];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
            self.isSearchEmpty = NO;
        } else{
            if(self.currentPage==0){
                self.contacts = [NSMutableArray arrayWithCapacity:[contactResponse count]];
            }
            for (SWFUserContact *uc in contactResponse){
                [self.contacts addObject:uc];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            });
            self.isEmpty = NO;
        }
        if ([contactResponse count] < SWFDefaultContactCount){
            if ([query length] > 0){
                self.searchToTail = YES;
            }else{
                
                self.contactToTail = YES;
            }
        }
    });
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *dataSource = self.contacts;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        dataSource = self.searchedContacts;
        if (![self.searchBar.text length]) {
            return 0;
        }
        if (self.searchToTail){
            return [dataSource count];
        }else{
            return [dataSource count] + 1;
        }
    }
    if (self.contactToTail || (self.source == 1 && [dataSource count] > 0)){        return [dataSource count];
    }else{
        return [dataSource count] + 1;
    }
}

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *dataSource = self.contacts;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        dataSource = self.searchedContacts;
    }
    return (indexPath.row < [dataSource count]);
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *dataSource = self.contacts;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        dataSource = self.searchedContacts;
    }
    if (indexPath.row < [dataSource count]) {
        @try {
            callback([dataSource objectAtIndex:indexPath.row]);
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.reason);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL searching = NO;
    static NSString *contactCellIdentifier = @"ContactCellIdentifier";
    NSMutableArray *dataSource = self.contacts;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        dataSource = self.searchedContacts;
        searching = YES;
    }
    if(indexPath.row < [dataSource count]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: contactCellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:contactCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.tag = -1;
        }
        if (indexPath.row > [dataSource count]) {
            return cell;
        }
        if(cell.tag != indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"default-user"];
        }
        cell.tag = indexPath.row;
        SWFUserContact *contact = [dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = contact.name;
        if ([contact.ucs count] > 1){
            cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"ui.contactMethods", @""), [contact.ucs count]];
        }else if ([contact.ucs count] == 0){
            cell.detailTextLabel.text = NSLocalizedString(@"ui.noContactMethods", @"");
        }else  if ([contact.ucs count] == 1){
            NSString *svr = contact.avatar.svr;
            NSString *svr_local_name = [NSString stringWithFormat:@"svr.%@", contact.avatar.svr];
            svr = NSLocalizedString(svr_local_name, @"");
            cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"ui.contactMethodFrom", @""), svr];
        }
        cell.imageView.image = [SWFAvatarHelper displayAvatar:contact.avatar.avatar callback:^(id img) {
            if(cell.tag == indexPath.row){
                cell.imageView.image = img;
            }
        } roundCorner:NO];
        self.busy = NO;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SWFTableCellLoadingIdentifer];
        if(!self.isEmpty && !searching){
            self.currentPage ++;
            [self loadContacts:nil];
        }else if (!self.isSearchEmpty && searching){
            self.currentSearchedPage ++;
            [self loadContacts:self.currentSearchQuery];
        }
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *dataSource = self.contacts;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        dataSource = self.searchedContacts;
    }
    if (indexPath.row < [dataSource count]) {
        return 50.0;
    }else{
        return 60.0;
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (![searchString length]) {
        return NO;
    }
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"SWFUILoadingCell" bundle:nil] forCellReuseIdentifier:SWFTableCellLoadingIdentifer];
    self.busy = NO;
    self.currentSearchedPage = 0;
    self.currentSearchQuery = searchString;
    self.isSearchEmpty = YES;
    self.searchToTail = NO;
    [self.searchedContacts removeAllObjects];
    [self loadContacts:searchString];
    return YES;
}

@end
