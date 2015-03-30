//
//  SWFSearchNewsViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-26.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFTrackedViewController.h"
#import "SWFNewsDelegates.h"

@interface SWFSearchNewsViewController : SWFTrackedViewController <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property SWFNewsDelegates *delegates;
@property NSString *kw;

@end
