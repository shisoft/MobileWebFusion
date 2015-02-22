//
// Created by Jack Shi on 22/2/15.
// Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import "SWFMyViewController.h"
#import "SWFBookmarkViewController.h"
#import "SWFMySwipeViewController.h"
#import "SWFUIModifiers.h"


@implementation SWFMyViewController {

}

@synthesize swipeViewController;

- (void)viewWillAppear:(BOOL)animated {
    [SWFUIModifiers manualBottomTabBarInsetsFor:self.quickDialogTableView];
    [super viewWillAppear:animated];
}


- (void)onFavourites:(QLabelElement *)buttonElement {
    SWFBookmarkViewController *bmvc = [[SWFBookmarkViewController alloc] initWithNibName:@"SWFBookmarkViewController" bundle:nil];
    [self.navigationController pushViewController:bmvc animated:YES];
}

- (void)onSettings:(QLabelElement *)buttonElement {
    [[swipeViewController swipeView] scrollToItemAtIndex:1 duration:0.5];
}


@end