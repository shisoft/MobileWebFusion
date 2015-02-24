//
//  SWFDiscoverViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-26.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFDiscoverViewController.h"
#import "SWFDiscoveryRequest.h"
#import "NSDate+SWFPersistance.h"
#import "SWFNews.h"
#import "SWFCodeGenerator.h"
#import "SWFWebBrowserViewController.h"
#import "SWFDiscoverCategoriesViewController.h"
#import "SWFNewsDelegates.h"
#import "SWFGetStarCategoriesRequest.h"
#import "Underscore.h"

@interface SWFDiscoverViewController ()

@end

@implementation SWFDiscoverViewController

static int SWFStreamDiscoverCount = 20;
static double SWFStreamDiscoverThreshold = 0.02;

UIActionSheet *actionSheet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"func.news", @"");
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedCatrgories = [[NSArray alloc] init];
    self.title = NSLocalizedString(@"func.Discover", @"");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ui.discoveryCategory", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(catrgories)];
    self.delegates = [[SWFNewsDelegates alloc] initWithWebView:self.webView ViewController:self getNews:^id{
        SWFDiscoveryRequest *discovery = [[SWFDiscoveryRequest alloc] init];
        discovery.before = self.delegates.pageLastNewsDate;
        discovery.count = SWFStreamDiscoverCount;
        discovery.cats = [Underscore.array(self.selectedCatrgories).each(^(NSDictionary * d){
            [d objectForKey:@"id"];
        }).unwrap componentsJoinedByString:@","];
        return [discovery streamDiscover];
    } name:@"discoverNews"];
    [self.delegates manualBottomInsets];
    [self loadStaredCategories];
    //[super changeNavBarColor:[[UIColor alloc] initWithRed:137 / 255.0 green:64 / 255.0 blue:131 / 255.0 alpha:1.0]];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadStaredCategories{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWFGetStarCategoriesRequest *gscr = [[SWFGetStarCategoriesRequest  alloc] init];
        self.selectedCatrgories = [gscr getStarCategories];
    });
}

-(void)reloadNews{
    [self.delegates resetParameteres];
    [self.delegates loadNews];
}

- (void)didWillAppear:(BOOL)animated{
    
}

- (void)catrgories{
    SWFDiscoverCategoriesViewController *dcvc = [[SWFDiscoverCategoriesViewController alloc] initWithNibName:@"SWFDiscoverCategoriesViewController" bundle:nil];
    [self.navigationController pushViewController:dcvc animated:YES];
    [dcvc link:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
