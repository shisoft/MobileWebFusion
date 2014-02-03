//
//  SWFADBannerDelagates.m
//  webfusion
//
//  Created by Jack Shi on 13-10-26.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFADBannerDelagates.h"

@implementation SWFADBannerDelagates

-(SWFADBannerDelagates*) initWithRootViewController:(UIViewController*)rootViewController View:(UIView*)view{
    self.rootViewController = rootViewController;
    if (!self.banner) {
        self.banner = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        self.banner.delegate = self;
        self.banner.adUnitID = @"a1526bbe4009ea6";
        dispatch_async(dispatch_get_main_queue(), ^{
            if(view){
                [view addSubview:self.banner];
            }
            self.banner.hidden = YES;
            self.banner.backgroundColor = [UIColor clearColor];
            self.banner.rootViewController = self.rootViewController;
            [self.banner loadRequest:[GADRequest request]];
        });
    }
    self.isAdLoaded = NO;
    return self;
}

// Called before the add is shown, time to move the view
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    self.AdLoaded();
    self.banner.hidden = NO;
    self.isAdLoaded = YES;
}

// Called when an error occured
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    self.AdFailed();
    self.banner.hidden = YES;
    self.isAdLoaded = NO;
}

-(void)refreshAd{
    if(self.isAdLoaded){
        [self.banner loadRequest:[GADRequest request]];
    }
}

@end
