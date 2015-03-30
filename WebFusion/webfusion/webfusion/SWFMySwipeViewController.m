//
//  SWFMySwipeViewController.m
//  webfusion
//
//  Created by Jack Shi on 22/2/15.
//  Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import "SWFMySwipeViewController.h"

@interface SWFMySwipeViewController ()

@end

@implementation SWFMySwipeViewController

@synthesize swipeView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SWFMySwipeViewController *)initWithViewControllersToSwap:(NSArray *)vcs {
    self = [self initWithNibName:@"SWFMySwipeViewController" bundle:nil];
    self.views = vcs;
    swipeView.alignment = SwipeViewAlignmentEdge;
    swipeView.frame = [SWFAppDelegate getDefaultInstance].window.frame;
    swipeView.bounces = NO;
    [self.swipeView reloadData];
    return self;
}


- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return [self.views count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    CGFloat currentOriginX = 0;
    UIView *v = (UIView *) [_views[(NSUInteger) index] view];
    CGRect frame = v.frame;
    frame.origin.x = currentOriginX;
    v.frame = frame;
    return v;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
