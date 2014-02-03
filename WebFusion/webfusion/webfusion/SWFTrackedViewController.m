//
//  SWFTrackedViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-9-28.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFTrackedViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface SWFTrackedViewController ()

@end

@implementation SWFTrackedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *scrName = self.title;
    if (![scrName length]) {
        scrName = [NSString stringWithFormat:@"<%@>",NSStringFromClass([self class])];
    }
    id tracker = [[GAI sharedInstance] defaultTracker];
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:scrName];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    NSLog(@"HTI:%@",scrName);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
