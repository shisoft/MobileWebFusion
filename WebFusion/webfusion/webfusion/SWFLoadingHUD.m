//
//  SWFLoadingHUD.m
//  webfusion
//
//  Created by Jack Shi on 13-9-4.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFLoadingHUD.h"

@implementation SWFLoadingHUD

- (SWFLoadingHUD *) initWithBody: (NSString*) body{
    self.hudView = nil;
    self.done = NO;
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(!self.done){
            self.hudView = [MBHUDView hudWithBody:body type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0 show:YES];
        }
    });
    return self;
}

- (void)dismiss{
    self.done = YES;
    [self.hudView dismiss];
}

@end
