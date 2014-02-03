//
//  SWFADBannerDelagates.h
//  webfusion
//
//  Created by Jack Shi on 13-10-26.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"

@interface SWFADBannerDelagates : NSObject <GADBannerViewDelegate>

@property GADBannerView *banner;
@property BOOL isAdLoaded;
@property (nonatomic,copy) void(^AdLoaded)(void);
@property (nonatomic,copy) void(^AdFailed)(void);
@property UIViewController* rootViewController;

-(SWFADBannerDelagates*) initWithRootViewController:(UIViewController*)rootViewController View:(UIView*)view;
-(void)refreshAd;

@end
