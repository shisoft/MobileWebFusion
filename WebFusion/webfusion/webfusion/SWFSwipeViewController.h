//
//  SWFNewsSwipeViewController.h
//  webfusion
//
//  Created by Jack Shi on 3/10/14.
//  Copyright (c) 2014 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@interface SWFSwipeViewController : UIViewController <SwipeViewDelegate, SwipeViewDataSource>

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (nonatomic) NSArray *views;

- (SWFSwipeViewController*) initWithViewControllersToSwap:(NSArray*) vcs;

@end
