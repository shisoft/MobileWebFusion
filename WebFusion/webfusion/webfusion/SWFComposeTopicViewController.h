//
//  SWFComposeTopicViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-14.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TITokenField.h"
#import "SWFTopicsViewController.h"
#import "SWFTrackedViewController.h"

@class SWFComposeTopicContentViewController;

@interface SWFComposeTopicViewController : SWFTrackedViewController <TITokenFieldDelegate, UITextViewDelegate>

@property TITokenFieldView * _tokenFieldView;
@property UIWebView *contentView;
@property NSMutableDictionary *contactDict;
@property NSMutableArray *names;
@property SWFTopicsViewController *tvc;

@end
