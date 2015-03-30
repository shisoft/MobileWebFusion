//
// Created by Jack Shi on 22/2/15.
// Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import "SWFMyViewController.h"
#import "SWFBookmarkViewController.h"
#import "SWFUIModifiers.h"
#import "SWFPreferencesViewController.h"


@implementation SWFMyViewController {

}

@synthesize swipeViewController;

- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStyleBordered target:self action:@selector(onSettings)];
    [super viewDidLoad];
}

- (void)onFavourites:(QLabelElement *)buttonElement {
    SWFBookmarkViewController *bmvc = [[SWFBookmarkViewController alloc] initWithNibName:@"SWFBookmarkViewController" bundle:nil];
    [self.navigationController pushViewController:bmvc animated:YES];
}

- (void)onSettings{
    SWFPreferencesViewController *preferencesView = (SWFPreferencesViewController *) [[SWFPreferencesViewController alloc] initWithRoot:[[QRootElement alloc] initWithJSONFile:@"preferences-lite"]];
    [self.navigationController pushViewController:preferencesView animated:YES];
}


@end