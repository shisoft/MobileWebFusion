 //
//  SWFSplashViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-6-29.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SWFLeftSideMenuViewController.h"
#import "SWFNewsViewController.h"
#import "SWFSplashViewController.h"
#import "SWFLoginViewController.h"
#import "SWFLoginRequest.h"
#import "SWFWrapper.h"
#import "SWFPoll.h"
#import "CHKeychain.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "SWFAliveUserViewController.h"
#import "SWFSwipeViewController.h"

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

@implementation SWFSplashViewController

@synthesize labelLogging;
@synthesize buttonLogin;

BOOL logging = YES;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    self.title = NSLocalizedString(@"appName", @"");
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.logoImageView.image = [UIImage imageNamed:@"splashLogo"];
    [self.buttonLogin setTitle:NSLocalizedString(@"ui.continue", @"") forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

- (void)hideLogging{
    [self resetLoggingUI];
    [UIView beginAnimations:@"fade" context:NULL];
    [UIView setAnimationDuration:1.5];
    buttonLogin.alpha = 1.0f;
    labelLogging.alpha = 1.0f;
    labelLogging.text = NSLocalizedString(@"appName", @"");
    [UIView commitAnimations];
}

- (void)resetLoggingUI{
    if(!ani){
        ani = YES;
        labelLogging.alpha = 1.0f;
        buttonLogin.alpha = 0.0f;
        logging = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self resetLoggingUI];
    UIImage *backgroundPatternImage = [UIImage imageNamed:@"splashBackground"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPatternImage];
    [self login];
    [super viewWillAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated{
    ani = NO;
    
}

- (void) login{
    logging = YES;
    [self rotateLogoDown1];
    [[SWFAppDelegate getDefaultInstance] login:^{
        [self constructureMainView];
    } onWrong:^{
        [self gotoLoginView];
    } onFailed:^{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"appName", @"")
                                    message:NSLocalizedString(@"err.no-server", @"")
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"ui.ok", @"")
                          otherButtonTitles:nil] show];
        logging = NO;
        [self hideLogging];
    } onEmpty:^{
        logging = NO;
        [self hideLogging];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonLoginPressed:(id)sender {
    [self gotoLoginView];
}

-(void)gotoLoginView{
    SWFLoginViewController *loginViewController =[[SWFLoginViewController alloc] initWithRoot:[[QRootElement alloc] initWithJSONFile:@"login"]];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
}

- (void)gotoRegisterView{}

- (void)constructureMainView{
    SWFAppDelegate *swfad = [SWFAppDelegate getDefaultInstance];
    swfad.rootViewController = [[UITabBarController alloc] init];
    
    SWFSwipeViewController* newsSwipeView = [[SWFSwipeViewController alloc] initWithViewControllersToSwap:
                                             [NSArray arrayWithObjects:
                                              [SWFAppDelegate generateCenterView:[SWFNewsViewController class] name:@"SWFNewsViewController"],
                                              [SWFAppDelegate generateCenterView:[SWFDiscoverViewController class] name:@"SWFDiscoverViewController"],
                                              [SWFAppDelegate generateCenterView:[SWFSearchNewsViewController class] name:@"SWFSearchNewsViewController"],
                                              [SWFAppDelegate generateCenterView:[SWFNewsTrendViewController class] name:@"SWFNewsTrendViewController"],
                                              nil]];
    
    UIViewController* topicView = [SWFAppDelegate generateCenterView:[SWFTopicsViewController class] name:@"SWFTopicsViewController"];
    
    UIViewController* contactView = [SWFAppDelegate generateCenterView:[SWFContactsViewController class] name:@"SWFContactsViewController"];
    
    UIViewController* myView = [SWFAppDelegate generateCenterView:[SWFPreferencesViewController class] name:@"SWFPreferencesViewController"];
    
    UIViewController* centerController = [SWFAppDelegate wrapCenterView:[[SWFNewsViewController alloc] initWithNibName:@"SWFNewsViewController" bundle:nil]];

    [swfad.window.rootViewController removeFromParentViewController];
    swfad.window.rootViewController = swfad.rootViewController;
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

BOOL ani = YES;
NSInteger rTimes = 1;

- (void)rotateLogoDown1{
    NSTimeInterval Duration = 1;
    
    if(logging == NO){
        Duration = 10;
    }else{
        Duration = 5;
    }
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    UIViewAnimationOptions ao = UIViewAnimationOptionCurveLinear;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView animateWithDuration:Duration delay:0 options:ao animations:^{
        self.logoImageView.transform = CGAffineTransformMakeRotation(M_PI_2 * rTimes);
    } completion:^(BOOL finished) {
        if(!ani){
            return;
        }
        rTimes++;
        if(rTimes > 4){
            rTimes = 1;
        }
        [self rotateLogoDown1];
    }];
}
@end
