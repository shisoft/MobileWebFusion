//
//  SWFAppDelegate.h
//  webfusion
//
//  Created by Jack Shi on 13-6-26.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFLeftSideMenuViewController.h"

extern NSString *const SWFUserNameKeychainItemName;
extern NSString *const SWFUserPasswordKeychainItemName;
extern NSString *const SWFUserPasswordKeychainContainerName;

static const int SWFItemFetchCount = 20;

extern dispatch_group_t SWFBackgroundTasks;

@interface SWFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype) getDefaultInstance;
+ (UINavigationController*)wrapCenterView:(UIViewController*) viewController;
+ (UIViewController*)generateCenterView:(Class) class name:(NSString*)name;

@property BOOL connected;
@property (nonatomic,strong) UITabBarController *rootViewController;
@property  (nonatomic) dispatch_group_t SWFBackgroundTasks;
@property  (nonatomic,strong) NSString *currentUser;

@property NSMutableDictionary *userFeatures;

@property BOOL networkWatcherActiviated;

- (BOOL) hasFeature:(NSString*)feature;
- (BOOL) hasFeature:(NSString*)feature ucid:(id)ucid;
+ (void)logout;
+ (void)initializePNS;

- (void) login:(void(^)())succeed onWrong:(void(^)())wrong onFailed:(void(^)())failed onEmpty:(void(^)())empty;

@end
