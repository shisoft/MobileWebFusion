//
//  SWFNewsSwipeViewController.m
//  webfusion
//
//  Created by Jack Shi on 3/10/14.
//  Copyright (c) 2014 Shisoft Corporation. All rights reserved.
//

#import "SWFSwipeViewController.h"

@interface SWFSwipeViewController ()

@end

@implementation SWFSwipeViewController

-(SWFSwipeViewController*) initWithViewControllersToSwap:(NSArray *)vcs{
    self = [self initWithNibName:@"SWFSwipeViewController" bundle:nil];
    self.views = vcs;
    _swipeView.alignment = SwipeViewAlignmentEdge;
    _swipeView.pagingEnabled = true;
    _swipeView.itemsPerPage = 1;
    _swipeView.truncateFinalPage = YES;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return [_views count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    return [[_views objectAtIndex:index] view];
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
