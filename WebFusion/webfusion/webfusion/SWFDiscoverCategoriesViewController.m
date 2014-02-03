//
//  SWFDiscoverCategoriesViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-26.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFDiscoverCategoriesViewController.h"
#import "SWFGetTopicExplanationsRequest.h"
#import "SWFWrapper.h"
#import "SWFGetUserTopicDistRequest.h"
#import "SWFDiscoverViewController.h"

@interface SWFDiscoverCategoriesViewController ()

@end

@implementation SWFDiscoverCategoriesViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)myInterests{
    [self.userSelectedTopics removeAllObjects];
    [self.tableView reloadData];    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)link:(SWFDiscoverViewController*)dvc{
    self.dvc = dvc;
    self.userSelectedTopics = [[NSMutableArray alloc] initWithArray:dvc.selectedCatrgories];
    self.needCopy = [self.userSelectedTopics count] <= 0;
    [self loadCategories];
    self.navigationItem.rightBarButtonItem.enabled = [self.userSelectedTopics count] > 0;
}

- (void) viewWillDisappear:(BOOL)animated{
    self.dvc.selectedCatrgories = [[NSArray alloc] initWithArray:self.userSelectedTopics];
    [self.dvc reloadNews];
}

- (void)loadCategories{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        SWFGetTopicExplanationsRequest *gter = [[SWFGetTopicExplanationsRequest alloc] init];
        SWFWrapper *w = [gter getTopicExplanations];
        if (![w isKindOfClass:[SWFWrapper class]]) {
            return;
        }
        self.categoriesMap = w.d;
        self.categories = [[self.categoriesMap allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [self.categoriesMap[obj1] compare:self.categoriesMap[obj2] options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
        }];
        SWFGetUserTopicDistRequest *gutdr = [[SWFGetUserTopicDistRequest alloc] init];
        NSArray *utds = [gutdr getUserTopicDist];
        double sum = 0.0;
        for (NSNumber *utd in utds) {
            sum += ([utd respondsToSelector:@selector(doubleValue)]) ? [utd doubleValue] : 0;
        }
        sum /= (double)[utds count];
        self.userTopDist = [[NSMutableArray alloc] init];
        for (int i = 0; i< [utds count]; i++) {
            NSNumber *utd = [utds objectAtIndex:i];
            double d = ([utd respondsToSelector:@selector(doubleValue)]) ? [utd doubleValue] : 0;
            NSString *sKey = [NSString stringWithFormat:@"%d",i];
            if (d - sum > 0.02 && [self.categories containsObject:sKey]) {
                [self.userTopDist addObject:sKey];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"categoryCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    id key = self.categories[indexPath.row];
    cell.textLabel.text = self.categoriesMap[key];
    NSMutableArray *source;
    
    if ([self.userSelectedTopics count] > 0) {
        source = self.userSelectedTopics;
    }else{
        source = self.userTopDist;
    }
    
    if ([source containsObject:key])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    id key = self.categories[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.userSelectedTopics count] <= 0 && self.needCopy) {
        self.userSelectedTopics = [[NSMutableArray alloc] initWithArray:self.userTopDist copyItems:YES];
        self.needCopy = NO;
    }
    
    if ([self.userSelectedTopics containsObject:key])
    {
        [self.userSelectedTopics removeObject:key];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        [self.userSelectedTopics addObject:key];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView selectRowAtIndexPath:nil
                           animated:YES
                     scrollPosition:UITableViewScrollPositionNone];
}

@end
