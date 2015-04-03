//
// Created by Jack Shi on 22/2/15.
// Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SWFUIModifiers : NSObject

+ (void)manualBottomTabBarInsetsFor: (UIView*) view;
+ (void)manualBottomToolBartInsetsFor: (UIView*) view;
+ (void)manualButtonInsetFor: (UIView*)view With:(int)height;

@end