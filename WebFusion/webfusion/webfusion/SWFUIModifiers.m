//
// Created by Jack Shi on 22/2/15.
// Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import "SWFUIModifiers.h"


@implementation SWFUIModifiers {

}

+ (void)manualBottomTabBarInsetsFor: (UIView*) view{
    [self manualButtonInsetFor:view With:49];
}

+ (void)manualBottomToolBartInsetsFor: (UIView*) view{
    [self manualButtonInsetFor:view With:44];
}

+ (void)manualButtonInsetFor: (UIView*)view With:(int)height {
    if ([view respondsToSelector:@selector(scrollIndicatorInsets)]){
        UIEdgeInsets scrollBarInsets = [(UIScrollView *) view scrollIndicatorInsets];
        UIEdgeInsets scrollBarInsetsCorrection = UIEdgeInsetsMake(scrollBarInsets.top, scrollBarInsets.left, height, scrollBarInsets.right);
        [(UIScrollView *) view setScrollIndicatorInsets:scrollBarInsetsCorrection];
    }
    if ([view respondsToSelector:@selector(contentInset)]){
        UIEdgeInsets contentInsets = [(UIScrollView *) view contentInset];
        UIEdgeInsets contentInsetsCorrection = UIEdgeInsetsMake(contentInsets.top, contentInsets.left, height, contentInsets.right);
        [(UIScrollView *) view setContentInset:contentInsetsCorrection];
    }
}

@end