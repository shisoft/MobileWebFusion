//
//  SWFMySwipeViewController.h
//  webfusion
//
//  Created by Jack Shi on 22/2/15.
//  Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@interface SWFMySwipeViewController : UIViewController <SwipeViewDataSource, SwipeViewDelegate>

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (nonatomic) NSArray *views;
- (SWFMySwipeViewController*) initWithViewControllersToSwap:(NSArray*) vcs;

@end
