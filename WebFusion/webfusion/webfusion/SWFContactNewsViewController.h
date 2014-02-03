//
//  SWFContactNewsViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-8-12.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFNewsDelegates.h"
#import "SWFUserContact.h"
#import "SWFTrackedViewController.h"

@interface SWFContactNewsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property SWFNewsDelegates *delegates;
@property SWFUserContact *uc;

@end
