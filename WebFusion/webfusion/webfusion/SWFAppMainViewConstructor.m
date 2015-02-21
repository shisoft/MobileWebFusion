//
//  SWFAppMainViewConstructor.m
//  webfusion
//
//  Created by Jack Shi on 18/2/15.
//  Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import "SWFAppMainViewConstructor.h"

#import "SWFLeftSideMenuViewController.h"
#import "SWFTopicsViewController.h"
#import "SWFNewsViewController.h"
#import "SWFPlacesViewController.h"
#import "SWFContactsViewController.h"
#import "SWFPreferencesViewController.h"
#import "SWFBookmarkViewController.h"
#import "SWFDiscoverViewController.h"
#import "SWFSearchNewsViewController.h"
#import "SWFNewsTrendViewController.h"
#import "SWFLoginViewController.h"
#import "SwipeView.h"
#import "SWFNewsSwipeViewController.h"
#import "SWFPoll.h"

@implementation SWFAppMainViewConstructor

+ (void) clearRootViewController{
    SWFAppDelegate *swfad = [SWFAppDelegate getDefaultInstance];
    if(swfad.rootViewController != nil){
        [swfad.rootViewController removeFromParentViewController];
    }
}

+ (void) constructureLoginView{
    [self clearRootViewController];
    SWFAppDelegate *swfad = [SWFAppDelegate getDefaultInstance];
    SWFLoginViewController *loginViewController =[[SWFLoginViewController alloc] initWithRoot:[[QRootElement alloc] initWithJSONFile:@"login"]];
    swfad.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    swfad.window.rootViewController = swfad.rootViewController;
}

+ (void)constructureMainView{
    [self clearRootViewController];
    SWFAppDelegate *swfad = [SWFAppDelegate getDefaultInstance];
    swfad.rootViewController = [[UITabBarController alloc] init];
    SWFNewsViewController* newsVC = [[SWFNewsViewController alloc] initWithNibName:@"SWFNewsViewController" bundle:nil];
    SWFDiscoverViewController* discoverVC = [[SWFDiscoverViewController alloc] initWithNibName:@"SWFDiscoverViewController" bundle:nil];
    SWFSearchNewsViewController* searchVC = [[SWFSearchNewsViewController alloc] initWithNibName:@"SWFSearchNewsViewController" bundle:nil];
    SWFNewsTrendViewController* trendVC = [[SWFNewsTrendViewController alloc] initWithNibName:@"SWFNewsTrendViewController" bundle:nil];
    
    UIViewController* newsSwipeView =
    [[SWFNewsSwipeViewController alloc] initWithViewControllersToSwap:
     @[[SWFAppDelegate wrapCenterView:newsVC],
       [SWFAppDelegate wrapCenterView:discoverVC],
       [SWFAppDelegate wrapCenterView:searchVC],
       [SWFAppDelegate wrapCenterView:trendVC]]];
    
    UIViewController* newsView = newsSwipeView;
    
    UIViewController* topicView = [SWFAppDelegate generateCenterView:[SWFTopicsViewController class] name:@"SWFTopicsViewController"];
    
    UIViewController* contactView = [SWFAppDelegate generateCenterView:[SWFContactsViewController class] name:@"SWFContactsViewController"];
    
    UIViewController* myView = [SWFAppDelegate wrapCenterView:[[SWFPreferencesViewController alloc] initWithRoot:[[QRootElement alloc] initWithJSONFile:@"preferences-lite"]]];
    
    swfad.rootViewController.viewControllers = [NSArray arrayWithObjects:
                                                newsView,
                                                topicView,
                                                contactView,
                                                myView,
                                                nil];
    
    NSArray* tabButtons = swfad.rootViewController.tabBar.items;
    
    UITabBarItem* newsTabButton = [tabButtons objectAtIndex:0];
    UITabBarItem* topicTabButton = [tabButtons objectAtIndex:1];
    UITabBarItem* contactTabButton = [tabButtons objectAtIndex:2];
    UITabBarItem* myTabButton = [tabButtons objectAtIndex:3];
    
    [newsTabButton setImage:[UIImage imageNamed:@"thin-010_newspaper_reading_news"]];
    [topicTabButton setImage:[UIImage imageNamed:@"thin-038_comment_chat_message"]];
    [contactTabButton setImage:[UIImage imageNamed:@"thin-326_phone_book_number_contact_profiles"]];
    [myTabButton setImage:[UIImage imageNamed:@"thin-191_user_profile_avatar"]];
    
    [newsTabButton setTitle:NSLocalizedString(@"ui.tab.news", nil)];
    [topicTabButton setTitle:NSLocalizedString(@"ui.tab.topic", nil)];
    [contactTabButton setTitle:NSLocalizedString(@"ui.tab.contact", nil)];
    [myTabButton setTitle:NSLocalizedString(@"ui.tab.my", nil)];

    [swfad.window.rootViewController removeFromParentViewController];
    swfad.window.rootViewController = swfad.rootViewController;
    
    [self initializePoll];
}

+ (void) initializePoll{
    [[SWFPoll defaultPoll] start];
}


@end
