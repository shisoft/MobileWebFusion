//
//  SWFDiscoverCategoriesViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-26.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGICommon.h>
#import "SWFDiscoverCategoriesViewController.h"
#import "SWFGetTopicExplanationsRequest.h"
#import "SWFWrapper.h"
#import "SWFGetUserTopicDistRequest.h"
#import "SWFDiscoverViewController.h"
#import "Underscore.h"
#import "SWFTypeaheadCategoriesRequest.h"

@interface SWFDiscoverCategoriesViewController ()

@end

@implementation SWFDiscoverCategoriesViewController

static NSString *SWFTableCellLoadingIdentifer = @"CellTableLoadingIdentifier";

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
    self.title = NSLocalizedString(@"ui.discoveryCategory", @"");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ui.myInterest", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(myInterests)];
    [self.tableView setTableHeaderView:self.searchBar];
    // Do any additional setup after loading the view from its nib.
}

- (void)myInterests{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)link:(SWFDiscoverViewController*)dvc{
    self.dvc = dvc;
    [self loadCategories:nil];
}

- (void) viewWillDisappear:(BOOL)animated{
    [self.dvc reloadNews];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.tableView){
        return self.dvc.selectedCatrgories.count;
    } else {
        return self.typeaheadCategories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"categoryCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    NSDictionary *cellDict;

    if (tableView == self.tableView){
        cellDict = self.dvc.selectedCatrgories[(NSUInteger) indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cellDict = self.typeaheadCategories[(NSUInteger) indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.textLabel.text = cellDict[@"name"];
    cell.tag = [cellDict[@"id"] integerValue];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (tableView == self.tableView){
        UnderscoreTestBlock isCell = ^BOOL(NSDictionary *catInfo){
            return [@(cell.tag) isEqualToNumber:catInfo[@"id"]];
        };
        BOOL contains = Underscore.any(self.dvc.selectedCatrgories, isCell);
        if (contains){
            cell.accessoryType = UITableViewCellAccessoryNone;
            self.dvc.selectedCatrgories = Underscore.reject(self.dvc.selectedCatrgories, isCell);
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSMutableArray *origArr = [NSMutableArray arrayWithArray:self.dvc.selectedCatrgories];
            [origArr addObject:@{@"id" : @(cell.tag), @"name" : cell.textLabel.text}];
            self.dvc.selectedCatrgories = origArr;
        }
    } else {
        [self.searchDisplayController setActive:NO animated:YES];
        NSMutableArray *origArr = [NSMutableArray arrayWithArray:self.dvc.selectedCatrgories];
        [origArr addObject:@{@"id" : @(cell.tag), @"name" : cell.textLabel.text}];
        self.dvc.selectedCatrgories = origArr;
        [self.tableView reloadData];
    }

    [tableView selectRowAtIndexPath:nil
                           animated:YES
                     scrollPosition:UITableViewScrollPositionNone];
}

- (void) loadCategories:(NSString *) query{
    if (query != nil){
        dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            SWFTypeaheadCategoriesRequest *tcr = [[SWFTypeaheadCategoriesRequest  alloc] init];
            tcr.types = query;
            NSArray *typeaheads = [tcr typeaheadCategories];
            if ([typeaheads isKindOfClass:NSArray.class]){
                self.typeaheadCategories = typeaheads;
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.searchDisplayController.searchResultsTableView reloadData];
                });
            }
        });
    } else {
        [self.tableView reloadData];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (![searchString length]) {
        return false;
    }
    @try {
        [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"SWFUILoadingCell" bundle:nil] forCellReuseIdentifier:SWFTableCellLoadingIdentifer];
        [self loadCategories:searchString];
        return YES;
    }
    @catch (NSException *exception) {
        return false;
    }
    @finally {

    }
}

@end
