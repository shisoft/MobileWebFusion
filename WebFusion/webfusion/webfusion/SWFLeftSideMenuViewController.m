//
//  SWFLeftSideMenuViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-1.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

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
#import "UIImage+SWFUtilities.h"
#import "CHKeychain.h"
#import "SWFAppDelegate.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "SWFNumberOfServicesRequest.h"
#import "SWFServicesViewController.h"
#import "Appirater.h"
#import "QRootElement.h"
#import "QRootElement+JsonBuilder.h"
#import "QElement+Appearance.h"
#import "SWFLeftSideBarAppeal.h"
#import "SWFNewThreadCountPoll.h"
#import <AVFoundation/AVFoundation.h>

@interface SWFLeftSideMenuViewController ()

@end

@implementation SWFLeftSideMenuViewController

AVAudioPlayer *audioPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstAppear = YES;
    self.quickDialogTableView.deselectRowWhenViewAppears = NO;
    UIImage *backgroundPatternImage = [UIImage imageNamed:@"grey"];
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:backgroundPatternImage];
    self.quickDialogTableView.backgroundView = backgroundView;
    [self checkAddServices];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource: @"newMsg" withExtension: @"aif"] error:NULL];
    [[SWFPoll defaultPoll] addDelegate:self forKey:@"thc"];
    [[SWFPoll defaultPoll] repoll];
    //UILabel *_statusHolderLabel = [[UILabel alloc] initWithFrame: [UIApplication sharedApplication].statusBarFrame];
    //_statusHolderLabel.backgroundColor = [UIColor whiteColor];
    //[self.view.superview addSubview:_statusHolderLabel];
    //[self.quickDialogTableView selectRowAtIndexPath:[[NSIndexPath alloc] initWithIndex:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [self resizeNavBar];
}

- (void)resizeNavBar{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        @try {
            self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
            UINavigationBar *navigationBar = [[self navigationController] navigationBar];
            CGRect frame = [navigationBar frame];
            frame.size.height = 0.0;
            [navigationBar setFrame:frame];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception.description);
        }
        @finally {
            
        }
    }else{
        self.navigationController.navigationBar.hidden = YES;
    }
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.firstAppear) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.quickDialogTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        self.firstAppear = NO;
    }
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self resizeNavBar];
}

- (void)checkAddServices{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        SWFNumberOfServicesRequest *nosr = [[SWFNumberOfServicesRequest alloc] init];
        SWFWrapper *nosw = [nosr numberOfServices];
        dispatch_async(dispatch_get_main_queue(),^{
            if ([nosw isKindOfClass:[SWFWrapper class]]) {
                if([[nosw stringValue] isEqualToString:@"0"]){
                    [UIAlertView alertViewWithTitle:NSLocalizedString(@"ui.addService", @"") message:NSLocalizedString(@"ui.requestAddService", @"") cancelButtonTitle:NSLocalizedString(@"ui.later", @"") otherButtonTitles:[[NSArray alloc] initWithObjects:NSLocalizedString(@"ui.startNow", @""), nil] onDismiss:^(int buttonIndex)
                    {
                        SWFServicesViewController *svc = [[SWFServicesViewController alloc] initWithNibName:@"SWFServicesViewController" bundle:nil];
                        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:svc];
                        svc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:svc action:@selector(dismissNav)];
                        [self presentViewController:nc animated:YES completion:nil];
                    } onCancel:^{
                        [SWFAppDelegate initializePNS];
                    }];
                } else {
                    [SWFAppDelegate initializePNS];
                    if([[nosw objectValueWithClass:[NSNumber class]] integerValue] > 2) {
                        [Appirater userDidSignificantEvent:YES];
                    }
                }
            }
        });
    });
}

- (void) setQuickDialogTableView:(QuickDialogTableView *)quickDialogTableView{
    [super setQuickDialogTableView:quickDialogTableView];
    self.root.appearance = [SWFLeftSideBarAppeal alloc];
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:SWFUserPasswordKeychainContainerName];
    self.userNameLabel = (QLabelElement *)[self.root elementWithKey:@"userName"];
    self.newsBadge = (QBadgeElement*)[self.root elementWithKey:@"newsBadge"];
    self.threadBadge = (QBadgeElement*)[self.root elementWithKey:@"threadBadge"];
    self.userNameLabel.title = [usernamepasswordKVPairs objectForKey:SWFUserNameKeychainItemName];
    
}

-(void) reloadList{
    dispatch_async(dispatch_get_main_queue(),^{
        NSIndexPath *selectedIndexPath = [self.quickDialogTableView indexPathForSelectedRow];
        [self.quickDialogTableView reloadData];
        @try {
            [self.quickDialogTableView deselectRowAtIndexPath:[self.quickDialogTableView indexPathForSelectedRow] animated:NO];
            [self.quickDialogTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTopics:(QLabelElement *)buttonElement {
    [SWFAppDelegate switchCenterView:[SWFTopicsViewController class] name:@"SWFTopicsViewController"];
}

- (void)onNews:(QBadgeElement *)buttonElement {
    [SWFAppDelegate switchCenterView:[SWFNewsViewController class] name:@"SWFNewsViewController"];
}

- (void)onMap:(QLabelElement *)buttonElement {
    [SWFAppDelegate switchCenterView:[SWFPlacesViewController class] name:@"SWFPlacesViewController"];
}

- (void)onContacts:(QLabelElement *)buttonElement {
    [SWFAppDelegate switchCenterView:[SWFContactsViewController class] name:@"SWFContactsViewController"];
}

- (void)onFavourites:(QLabelElement *)buttonElement {
    [SWFAppDelegate switchCenterView:[SWFBookmarkViewController class] name:@"SWFBookmarkViewController"];
}

- (void)onPreferences:(QLabelElement *)buttonElement {
    if ([SWFAppDelegate getCenterViewController:@"SWFPreferencesViewController"] == nil) {
        [SWFAppDelegate putCenterViewController:@"SWFPreferencesViewController" controller:  [SWFAppDelegate wrapCenterView:[[SWFPreferencesViewController alloc] initWithRoot:[[QRootElement alloc] initWithJSONFile:@"preferences-lite"]]]];
    }
    [SWFAppDelegate switchCenterView:[SWFPreferencesViewController class] name:@"SWFPreferencesViewController"];
}

- (void)onDiscover:(QLabelElement *)buttonElement {
    [SWFAppDelegate switchCenterView:[SWFDiscoverViewController class] name:@"SWFDiscoverViewController"];
}

- (void)onSearch:(QLabelElement *)buttonElement {
    [SWFAppDelegate switchCenterView:[SWFSearchNewsViewController class] name:@"SWFSearchNewsViewController"];
}

- (void)onTrend:(QLabelElement *)buttonElement {
    [SWFAppDelegate switchCenterView:[SWFNewsTrendViewController class] name:@"SWFNewsTrendViewController"];
}

- (void)onLogout:(QLabelElement *)buttonElement {
    [SWFAppDelegate logout];
}


- (id)poll:(SWFPoll *)poll objectForKey:(NSString *)key
{
    if(YES){
        SWFNewThreadCountPoll *poll = [[SWFNewThreadCountPoll alloc] init];
        poll.thvt = self.newThreadCount;
        return poll;
    }else{
        return nil;
    }
}

- (void)poll:(SWFPoll *)poll receivedObject:(id)object forKey:(NSString *)key
{
    if ([object respondsToSelector:@selector(integerValue)])
    {
        int thc = [object integerValue];
        if(thc != self.newThreadCount){
            self.newThreadCount = thc;
            if(thc > 0){
                self.threadBadge.badge = [NSString stringWithFormat:@"%d", self.newThreadCount];
                [audioPlayer play];
            }else{
                self.threadBadge.badge = nil;
            }
        }
        [self reloadList];
        [[SWFPoll defaultPoll] repoll];
    }
}


@end
