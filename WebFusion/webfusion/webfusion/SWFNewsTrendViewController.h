//
//  SWFNewsTrendViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-27.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFNavedCenterViewController.h"
#import "SWFNewsDelegates.h"

@interface SWFNewsTrendViewController : SWFNavedCenterViewController <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property SWFNewsDelegates *delegates;
@property NSString *kw;

-(void)reloadNews;

@end
