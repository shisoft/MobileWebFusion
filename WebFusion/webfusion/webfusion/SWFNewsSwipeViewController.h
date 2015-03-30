//
//  SWFNewsSwipeViewController.h
//  webfusion
//
//  Created by Jack Shi on 3/10/14.
//  Copyright (c) 2014 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@interface SWFNewsSwipeViewController : UIViewController <SwipeViewDelegate, SwipeViewDataSource>

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (nonatomic) NSArray *views;

- (SWFNewsSwipeViewController*) initWithViewControllersToSwap:(NSArray*) vcs;

@end
