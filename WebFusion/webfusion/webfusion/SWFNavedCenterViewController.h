//
//  SWFNavedCenterViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-2.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "SWFTrackedViewController.h"

@interface SWFNavedCenterViewController : SWFTrackedViewController

@property IIViewDeckController* deckController;

- (BOOL)toggleLeftView;
- (void)changeNavBarColor:(UIColor*)color;
+ (void)changeNavBarColor:(UIColor*)color nc:(UIViewController*)nc;
@property UIColor* barTintColor;

@end
