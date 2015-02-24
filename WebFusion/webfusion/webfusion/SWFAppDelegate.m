//
//  SWFAppDelegate.m
//  webfusion
//
//  Created by Jack Shi on 13-6-26.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>
#import <QuartzCore/QuartzCore.h>
#import "SWFAppDelegate.h"
#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFLoginRequest.h"
#import "SWFWrapper.h"
#import "SWFPoll.h"
#import "SWFRootViewController.h"
#import "SWFGetFeaturedUserServicesRequest.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "CHKeychain.h"
#import "Appirater.h"
#import "UIView+Toast.h"
#import "SWFRegDevicePNSRequest.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import "GAI.h"
#import "SWFAppMainViewConstructor.h"


NSString *const SWFUserNameKeychainItemName = @"net.shisoft.webfusion.keychainUserName";
NSString *const SWFUserPasswordKeychainItemName = @"net.shisoft.webfusion.keychainPassword";
NSString *const SWFUserPasswordKeychainContainerName = @"net.shisoft.webfusion.keychainUserPasswordContainer";
NSString *const SWFKeychainIdentifier = @"net.shisoft.webfusion.keychainIdentifier";
NSString *const SWFKeychainGroup = @"net.shisoft.webfusion.keychainGroup";


@implementation SWFAppDelegate

@synthesize rootViewController;
@synthesize SWFBackgroundTasks;
@synthesize currentUser;

+ (instancetype) getDefaultInstance
{
    return [UIApplication sharedApplication].delegate;
}

+ (UIViewController*) generateCenterView:(Class) class name:(NSString*)name{
    return [self wrapCenterView: [(UIViewController *) [class alloc] initWithNibName:name bundle:nil]];
}

+ (void)logout{
    [UIAlertView alertViewWithTitle:NSLocalizedString(@"func.logout", @"") message:NSLocalizedString(@"ui.confirmLogout", @"") cancelButtonTitle:NSLocalizedString(@"ui.cancel", @"") otherButtonTitles:[[NSArray alloc] initWithObjects:NSLocalizedString(@"ui.ok", @""), nil] onDismiss:^(int buttonIndex)
     {
         dispatch_group_notify([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_main_queue(),^{
             @try {
                 NSURLRequest *request = [NSURLRequest requestWithURL: [[NSURL alloc] initWithString:@"https://www.shisoft.net/LogoutAllSessions"]];
                 [NSURLConnection sendSynchronousRequest:request
                                       returningResponse:nil
                                                   error:NULL];
                 NSLog(@"%@", @"Logout");
             }
             @catch (NSException *exception) {
                 
             }
         });
         [[SWFPoll defaultPoll] stop];
         [CHKeychain delete:SWFUserPasswordKeychainContainerName];
         [SWFAppDelegate checkAndLoadAccount];
    } onCancel:^{
        
    }];
}

+ (UINavigationController*)wrapCenterView:(UIViewController*) viewController{
    return [[UINavigationController alloc] initWithRootViewController:viewController];
}


+ (void) checkAndLoadAccount {
    if ([CHKeychain load:SWFUserPasswordKeychainContainerName] != nil) {
        [SWFAppMainViewConstructor constructureMainView];
        [[self getDefaultInstance] login:^{
        } onWrong:^{
            [SWFAppMainViewConstructor constructureLoginView];
        } onFailed:^{
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"appName", @"")
                                        message:NSLocalizedString(@"err.no-server", @"")
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"ui.ok", @"")
                              otherButtonTitles:nil] show];
            [SWFAppMainViewConstructor constructureLoginView];
        } onEmpty:^{
            [SWFAppMainViewConstructor constructureLoginView];
        }];
    } else {
        [SWFAppMainViewConstructor constructureLoginView];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Crashlytics startWithAPIKey:@"c0502879ef3f1c26e0486675b716ae3a510bb103"];
    [self loadGoogleAnalytics];
    SWFBackgroundTasks = dispatch_group_create();
    
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(networkWatcher)
                                   userInfo:nil
                                    repeats:YES];
    [self loadAppirater];
    self.userFeatures = [[NSMutableDictionary alloc] init];
    [self initializeClient];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    [SWFAppDelegate checkAndLoadAccount];
    [[NSURLCache sharedURLCache] setMemoryCapacity:10*1024*1024];
    [[NSURLCache sharedURLCache] setDiskCapacity:100*1024*1024];
    
    return YES;
}

- (void)loadAppirater{
    [Appirater setAppId:@"558477831"];
    [Appirater setDaysUntilPrompt:2];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
}

- (void)loadGoogleAnalytics{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-44399483-1"];
}

- (void)networkWatcher{
    if (dispatch_group_wait(self.SWFBackgroundTasks, DISPATCH_TIME_NOW)){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        if (!self.networkWatcherActiviated){
            self.networkWatcherActiviated = YES;
            dispatch_group_notify(self.SWFBackgroundTasks, dispatch_get_main_queue(),^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [SWFAppDelegate getDefaultInstance].networkWatcherActiviated = NO;
            });
        }
    }
}


- (BOOL) hasFeature:(NSString*)feature{
    return [self hasFeature:feature ucid:nil];
}

- (BOOL) hasFeature:(NSString*)feature ucid:(id)ucid{
    if(ucid != nil){
        SWFGetFeaturedUserServicesRequest *gfusr = [[SWFGetFeaturedUserServicesRequest alloc] init];
        gfusr.feature = feature;
        gfusr.ucid = ucid;
        NSArray *r = [gfusr getFeaturedUserServices];
        if ([r isKindOfClass:[NSArray class]]){
            return [r count] > 0;
        }else{
            return NO;
        }
    }
    if (![[self.userFeatures allKeys] containsObject:feature]) {
        SWFGetFeaturedUserServicesRequest *gfusr = [[SWFGetFeaturedUserServicesRequest alloc] init];
        gfusr.feature = feature;
        NSArray *r = [gfusr getFeaturedUserServices];
        if ([r isKindOfClass:[NSArray class]]){
            [self.userFeatures setObject:[NSNumber numberWithBool:YES] forKey:feature];
        } else {
            return NO;
        }
    }
    return (NSNumber*)[self.userFeatures valueForKey:feature] > 0;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[SWFPoll defaultPoll] stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[SWFPoll defaultPoll] start];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void)initializePNS{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        SWFRegDevicePNSRequest *rdr = [[SWFRegDevicePNSRequest alloc] init];
        rdr.device = @"0";
        rdr.deviceId = token;
        NSLog(@"deviceToken: %@", token);
        [rdr regDevicePNS];
    });
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSString *str = [NSString stringWithFormat: @"Error: %@", error];
    //NSLog(str);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"%@", userInfo);
}

- (void) initializeClient
{
    // Set up default connection.
    CGIRemoteConnection *connection = [[CGIRemoteConnection alloc] initWithServerRoot:@"https://www.shisoft.net/ajax/%@"];
    //CGIRemoteConnection *connection = [[CGIRemoteConnection alloc] initWithServerRoot:@"http://10.0.0.130:8080/ajax/%@"];
    [connection makeDefaultServerRoot];
    connection.timeoutSeconds = [[NSNumber alloc] initWithDouble:30.0];
    connection.customUserAgent = @"Shisoft WebFusion iOS Client";
    connection.onError = ^(NSError* err, NSURLRequest* req){
        if ([[req.URL absoluteString] rangeOfString:@"Login"].location == NSNotFound && err != nil ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",err);
                if([SWFAppDelegate checkNetWorkIsOk]){
                    [self.window.viewForBaselineLayout makeToast:NSLocalizedString(@"ui.badNetwork", @"")];
                }else{
                    [self.window.viewForBaselineLayout makeToast:NSLocalizedString(@"ui.noNetwork", @"")];
                }
            });
        }
    };
}

- (void) login:(void(^)())succeed onWrong:(void(^)())wrong onFailed:(void(^)())failed onEmpty:(void(^)())empty{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        // Query keychain for previously stored username and password.
        [[SWFAppDelegate getDefaultInstance].userFeatures removeAllObjects];
        SWFLoginRequest *login = [[SWFLoginRequest alloc] init];
        NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:SWFUserPasswordKeychainContainerName];
        login.user = [usernamepasswordKVPairs objectForKey:SWFUserNameKeychainItemName];
        login.pass = [usernamepasswordKVPairs objectForKey:SWFUserPasswordKeychainItemName];
        if ([login.user length] && [login.pass length])
        {
            SWFWrapper *rv = [login login];
            if ([rv isKindOfClass:[SWFWrapper class]])
            {
                [SWFAppDelegate getDefaultInstance].connected = [rv boolValue];
                dispatch_async(dispatch_get_main_queue(),^{
                    if ([SWFAppDelegate getDefaultInstance].connected)
                    {
                        [SWFAppDelegate getDefaultInstance].currentUser = login.user;
                        succeed();
                    }else{
                        [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"err.wrongPassword", @"")  cancelButtonTitle:NSLocalizedString(@"ui.ok", @"") otherButtonTitles:nil onDismiss:nil onCancel:^{
                            wrong();
                        }];
                    }
                });
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    failed();
                });
                [SWFAppDelegate getDefaultInstance].connected = NO;
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),^{
                empty();
            });
        }
    });
}

+ (BOOL) checkNetWorkIsOk{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    // = flags & kSCNetworkReachabilityFlagsIsWWAN;
    BOOL nonWifi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    BOOL moveNet = flags & kSCNetworkReachabilityFlagsIsWWAN;
    
    return ((isReachable && !needsConnection) || nonWifi || moveNet) ? YES : NO;
}

@end
