//
//  SWFDiscoverViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-26.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFNavedCenterViewController.h"
#import "SWFNewsDelegates.h"

@interface SWFDiscoverViewController : SWFNavedCenterViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property NSArray *selectedCatrgories;

@property SWFNewsDelegates *delegates;

-(void)reloadNews;

@end
