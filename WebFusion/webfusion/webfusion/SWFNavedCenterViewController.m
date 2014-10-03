//
//  SWFNavedCenterViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-2.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFNavedCenterViewController.h"

@interface SWFNavedCenterViewController ()

@end

@implementation SWFNavedCenterViewController

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"items_tool"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftView)];
    if (!self.barTintColor) {
        [self changeNavBarColor:[[UIColor alloc] initWithRed:0 green:68 / 255.0 blue:95 / 225.0 alpha:1.0]];
    }
    // Do any additional setup after loading the view.
}

- (void)changeNavBarColor:(UIColor*)color{
    [SWFNavedCenterViewController changeNavBarColor:color nc:self];
    self.barTintColor = color;
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.barTintColor) {
        //[UINavigationBar appearance].tintColor = self.barTintColor;
    }
}

+ (void)changeNavBarColor:(UIColor*)color nc:(UIViewController*)nc{
    @try {
        nc.navigationController.navigationBar.barTintColor = color;
        nc.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor],UITextAttributeTextColor,
                                                   nil];
        //[[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        nc.navigationController.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
        nc.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [nc setNeedsStatusBarAppearanceUpdate];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
