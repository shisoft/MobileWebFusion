//
//  SWFMapPickerViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-6.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFMapPickerViewController.h"

@interface SWFMapPickerViewController ()

@end

@implementation SWFMapPickerViewController

@synthesize useMapButton;
@synthesize naviTitle;
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.naviTitle.title = NSLocalizedString(@"ui.selLocation", @"");
        self.useMapButton.title = NSLocalizedString(@"ui.use", @"");
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)useMapPressed:(id)sender {
}

- (IBAction)cancelMapPressed:(id)sender {
}
@end
