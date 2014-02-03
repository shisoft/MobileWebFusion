//
//  SWFAliveUserViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-10-28.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFAliveUserViewController.h"
#import "SWFGetAliveUserContactsRequest.h"
#import "SWFAvatarHelper.h"
#import "SWFAliveContactCell.h"
#import "SWFAliveContactItem.h"
#import "SWFUniversalContact.h"
#import "SWFTopicMessageViewController.h"
#import "IIViewDeckController.h"
#import "SWFAliveContactPoll.h"

@interface SWFAliveUserViewController ()

@end

@implementation SWFAliveUserViewController

static NSString *SWFTableCellLoadingIdentifer = @"CellTableLoadingIdentifier";

@synthesize searchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshHandle) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    UIView *searchContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(45, 0, 275, 45)];
    searchBar.tintColor = [UIColor grayColor];
    searchBar.barStyle = UIBarStyleBlackTranslucent;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    searchContainer.backgroundColor = [UIColor darkGrayColor];
    [searchContainer addSubview:searchBar];
    self.tableView.tableHeaderView = searchContainer;
    [self.tableView registerNib:[UINib nibWithNibName:@"SWFAliveContactCell" bundle:nil] forCellReuseIdentifier:@"AliveContactCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SWFUILoadingCell" bundle:nil] forCellReuseIdentifier:SWFTableCellLoadingIdentifer];
    [self stylish];
    self.isInForeground = NO;
    self.needRefresh = NO;
    self.pollResult = 0;
    self.aliveContacts = [[NSArray alloc] init];
    [[SWFPoll defaultPoll] addDelegate:self forKey:@"aucc"];
    [[SWFPoll defaultPoll] repoll];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)refreshHandle{
    self.pollResult = 0;
    [[SWFPoll defaultPoll] repoll];
}

- (void)loadAlive{
    self.needRefresh = NO;
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWFGetAliveUserContactsRequest *gauc = [[SWFGetAliveUserContactsRequest alloc] init];
        NSArray *arr = [gauc getAliveUserContacts];
        if([arr isKindOfClass:[NSArray class]]){
            self.aliveContacts = arr;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            });
        }
    });
}

- (void)stylish{
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.tableView.separatorColor = [UIColor grayColor];
    //self.tableView.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self resizeNavBar];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    self.isInForeground = YES;
    [self checkAndRefresh];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [searchBar resignFirstResponder];
    self.isInForeground = NO;
}

- (void)checkAndRefresh{
    if(self.needRefresh){
        [self loadAlive];
    }
}

- (void)resizeNavBar{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        @try {
            self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
            UINavigationBar *navigationBar = [[self navigationController] navigationBar];
            CGRect frame = [navigationBar frame];
            frame.size.height = 0.0;
            [navigationBar setFrame:frame];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception.description);
        }
        @finally {
            
        }
    }else{
        self.navigationController.navigationBar.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchResult) {
        return [self.searchResult count];
    }else{
        return [self.aliveContacts count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWFAliveContactItem *aci = nil;
    if (self.searchResult) {
        aci = [self.searchResult objectAtIndex:indexPath.row];
    }else{
        aci = [self.aliveContacts objectAtIndex:indexPath.row];
    }
    static NSString *CellIdentifier = @"AliveContactCell";
    SWFAliveContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell.loaded){
        [cell drawShadow];
        cell.loaded = YES;
    }
    cell.usernameLabel.text = aci.uc.name;
    cell.serviceImageView.image = [UIImage imageNamed:aci.us.gate];
    cell.serviceAccounrLabel.text = [aci.uc.avatar.scrName length] ? aci.uc.avatar.scrName : aci.uc.avatar.dispName;
    cell.avatarImageView.image = [SWFAvatarHelper displayAvatar:aci.uc.avatar.avatar callback:^(id img){
        if([cell.usernameLabel.text isEqualToString:aci.uc.name]){
            cell.avatarImageView.image = img;
        }
    } roundCorner:YES size:CGSizeMake(128, 128)];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    bgView.backgroundColor = [UIColor blackColor];
    cell.selectedBackgroundView = bgView;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *vc = [SWFAppDelegate getCenterViewController:@"SWFUserContactPrivateConversationViewController"];
        if (vc == nil) {
            vc = [SWFAppDelegate wrapCenterView:[[SWFTopicMessageViewController alloc] init]];
            [SWFAppDelegate putCenterViewController:@"SWFUserContactPrivateConversationViewController" controller: vc];
        }
        SWFTopicMessageViewController *ucpcvc = vc.viewControllers[0];
        IIViewDeckController *vdc = [SWFAppDelegate getDefaultInstance].deckViewController;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.2),dispatch_get_main_queue(), ^{
            [vdc closeRightViewBouncing:^(IIViewDeckController *controller) {
                vdc.centerController = vc;
                SWFAliveContactItem *aci = nil;
                if (self.searchResult) {
                    aci = [self.searchResult objectAtIndex:indexPath.row];
                }else{
                    aci = [self.aliveContacts objectAtIndex:indexPath.row];
                }
                ucpcvc.title = aci.uc.name;
                [ucpcvc.txMessage becomeFirstResponder];
                [ucpcvc.webView loadHTMLString:@"" baseURL:nil];
                [ucpcvc loadUserContactPrivateConversation:aci.uc];
            }];
        });
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

- (id)poll:(SWFPoll *)poll objectForKey:(NSString *)key
{
    if(self.aliveContacts){
        SWFAliveContactPoll *poll = [[SWFAliveContactPoll alloc] init];
        poll.ucct = self.pollResult;
        if (self.pollResult == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }
        return poll;
    }else{
        return nil;
    }
}

- (void)poll:(SWFPoll *)poll receivedObject:(id)object forKey:(NSString *)key
{
    if ([object respondsToSelector:@selector(integerValue)])
    {
        if([object integerValue] != self.pollResult){
            if(self.isInForeground){
                [self loadAlive];
            }else{
                self.needRefresh = YES;
            }
        }        self.pollResult = [object integerValue];
        [[SWFPoll defaultPoll] repoll];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (!self.aliveContacts || ![searchText length]) {
        self.searchResult = nil;
    }else{
        NSMutableArray *r = [[NSMutableArray alloc] init];
        for (SWFAliveContactItem *aci in self.aliveContacts) {
            if ([[NSString stringWithFormat:@"%@ %@ %@", aci.uc.name, aci.uc.avatar.scrName, aci.uc.avatar.dispName] rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [r addObject:aci];
            }
        }
        self.searchResult = r;
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

@end
