//
//  SWFNewsSwipeViewController.m
//  webfusion
//
//  Created by Jack Shi on 3/10/14.
//  Copyright (c) 2014 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGICommon.h>
#import "SWFNewsSwipeViewController.h"
#import "SWFNewsViewController.h"

@interface SWFNewsSwipeViewController ()

@end

@implementation SWFNewsSwipeViewController

@synthesize swipeView;

-(SWFNewsSwipeViewController*) initWithViewControllersToSwap:(NSArray *)vcs{
    self = [self initWithNibName:@"SWFNewsSwipeViewController" bundle:nil];
    self.views = vcs;
    for (int i = 0; i < [self.views count]; ++i) {
        id view = [[self.views objectAtIndex:i] viewControllers].firstObject;
        if ([view  respondsToSelector:@selector(setRefBadge:)]){
            [view setRefBadge:^{
                if (self.swipeView.currentItemIndex == i){
                    [self refreshTabBadgeForCurrentView];
                }
            }];
        }
    }
    swipeView.alignment = SwipeViewAlignmentEdge;
    swipeView.frame = [SWFAppDelegate getDefaultInstance].window.frame;
    swipeView.bounces = NO;
//    _swipeView.pagingEnabled = true;
//    _swipeView.itemsPerPage = 1;
//    _swipeView.truncateFinalPage = YES;
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
    CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
    CGFloat currentOriginX = 0;
    UIView *v = [[_views objectAtIndex:index] view];
    CGRect frame = v.frame;
    frame.origin.x = currentOriginX;
    v.frame = frame;
    currentOriginX += mainScreenBounds.size.width;
    return v;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    [self refreshTabBadgeForCurrentView];
}

- (void) refreshTabBadgeForCurrentView{
    id view = [[self.views objectAtIndex:self.swipeView.currentItemIndex] viewControllers].firstObject;
    self.title = [view title];
    NSInteger badgeNum = nil;
    if ([view respondsToSelector:@selector(getBadgeNum)]) {
        badgeNum = [view badgeNum];
    }
    NSString *badgeDisp = nil;
    if (badgeNum && badgeNum > 1){
        badgeDisp = [NSString stringWithFormat:@"%d", badgeNum];
    }
    self.tabBarItem.badgeValue = badgeDisp;
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
