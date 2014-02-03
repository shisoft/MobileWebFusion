//
//  SWFCustomStatusBar.h
//  webfusion
//
//  Created by Jack Shi on 13-7-7.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWFCustomStatusBar : UIWindow
{
    UILabel *_statusMsgLabel;
}

- (void)showStatusMessage:(NSString *)message;
- (void)hide;

@end