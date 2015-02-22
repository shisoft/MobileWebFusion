//
// Created by Jack Shi on 22/2/15.
// Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import "SWFUIModifiers.h"


@implementation SWFUIModifiers {

}

+ (void)manualBottomTabBarInsetsFor: (UIView*) view{
    int tabBarHeight = 49;
    if ([view respondsToSelector:@selector(scrollIndicatorInsets)]){
        UIEdgeInsets scrollBarInsets = [(UIScrollView *) view scrollIndicatorInsets];
        UIEdgeInsets scrollBarInsetsCorrection = UIEdgeInsetsMake(scrollBarInsets.top, scrollBarInsets.left, tabBarHeight, scrollBarInsets.right);
        [(UIScrollView *) view setScrollIndicatorInsets:scrollBarInsetsCorrection];
    }
    if ([view respondsToSelector:@selector(contentInset)]){
        UIEdgeInsets contentInsets = [(UIScrollView *) view contentInset];
        UIEdgeInsets contentInsetsCorrection = UIEdgeInsetsMake(contentInsets.top, contentInsets.left, tabBarHeight, contentInsets.right);
        [(UIScrollView *) view setContentInset:contentInsetsCorrection];
    }
}

@end