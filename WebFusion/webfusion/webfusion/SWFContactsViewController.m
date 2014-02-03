//
//  SWFContactsViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-16.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFContactsViewController.h"
#import "SWFUniversalContact.h"
#import "SWFAvatarHelper.h"
#import "SWFUserContact.h"
#import "SWFUserContactRequest.h"
#import "SWFContactDetailsViewController.h"
#import "SWFAddContactViewController.h"

@interface SWFContactsViewController ()

@end

@implementation SWFContactsViewController

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
    self.title = NSLocalizedString(@"func.contacts", @"");
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl]; //<- this is point to use. Add "scrollView" property.
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"SWFUILoadingCell" bundle:nil] forCellReuseIdentifier:SWFTableCellLoadingIdentifer];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.tableView setTableHeaderView:self.searchBar];
    [self loadContacts:nil];
    [super changeNavBarColor:[[UIColor alloc] initWithRed:215 / 255.0 green:94 / 255.0 blue:1 / 255.0 alpha:1.0]];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        bool canSend = [[SWFAppDelegate getDefaultInstance] hasFeature:@"CanAddContact"];
        dispatch_async(dispatch_get_main_queue(),^{
            self.navigationItem.rightBarButtonItem.enabled = canSend;
        });
    });
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
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
        SWFUserContactRequest *r = [[SWFUserContactRequest alloc] init];
        r.query = @"";
        r.group = @"";
        r.page = self.currentPage;
        if ([query length] > 0){
            r.query = query;
            r.page = self.currentSearchedPage;
        }
        NSArray *contactResponse = [r getContactNames];
        if(![contactResponse isKindOfClass:[NSArray class]]){
            return;
            self.busy = NO;
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

- (void) addContact{
    SWFAddContactViewController *acvc = [[SWFAddContactViewController alloc] initWithNibName:@"SWFAddContactViewController" bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:acvc];
    [self presentViewController:nc animated:YES completion:nil];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *dataSource = self.contacts;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        dataSource = self.searchedContacts;
        if (self.searchToTail){
            return [dataSource count];
        }else{
            return [dataSource count] + 1;
        }
    }
    if (self.contactToTail){
        return [dataSource count];
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
            SWFUserContact *uc = [dataSource objectAtIndex:indexPath.row];
            if (uc == nil) {
                return;
            }
            SWFContactDetailsViewController *cdvc = [[SWFContactDetailsViewController alloc] initWithNibName:@"SWFContactDetailsViewController" bundle:nil];
            [self.navigationController pushViewController:cdvc animated:YES];
            [cdvc loadUserContact:uc];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.reason);
        }
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    @try {
        BOOL searching = NO;
        static NSString *contactCellIdentifier = @"ContactCellIdentifier";
        NSMutableArray *dataSource = self.contacts;
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            dataSource = self.searchedContacts;
            searching = YES;
        }
        if(indexPath.row < [dataSource count]){
            cell = [tableView dequeueReusableCellWithIdentifier: contactCellIdentifier];
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
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:SWFTableCellLoadingIdentifer];
            if(!self.isEmpty && !searching){
                self.currentPage ++;
                [self loadContacts:nil];
            }else if (!self.isSearchEmpty && searching){
                self.currentSearchedPage ++;
                [self loadContacts:self.currentSearchQuery];
            }
        }
    }
    @catch (NSException *exception) {
        cell = nil;
    }
    @finally {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nil"];
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
        return false;
    }
    @try {
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
    @catch (NSException *exception) {
        return false;
    }
    @finally {
        
    }
}

@end
