		//
//  SWFPreferencesViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-23.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFPreferencesViewController.h"
#import "CHKeychain.h"
#import "SWFGetUserNicknameRequest.h"
#import "SWFWrapper.h"
#import "SWFChangeNicknameRequest.h"
#import "SWFNumberOfServicesRequest.h"
#import "SWFServicesViewController.h"
#import "SWFAlterPasswordViewController.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "SWFWebBrowserViewController.h"
#import "Appirater.h"
#import "SWFNavedCenterViewController.h"
#import "SWFCachePolicy.h"
#import <MessageUI/MessageUI.h>
#import <CGIJSONObject/CGICommon.h>
#import "QElement+Appearance.h"
#import "QLabelElement.h"

@interface SWFPreferencesViewController ()

@end

@implementation SWFPreferencesViewController

static NSString *SWFUserNickNameCacheFileName = @"userNickName";
static NSString *SWFUserNumberOfServiceCacheFileName = @"userNumberOfService";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setQuickDialogTableView:(QuickDialogTableView *)quickDialogTableView{
    [super setQuickDialogTableView:quickDialogTableView];
    self.username = (QLabelElement *)[self.root elementWithKey:@"username"];
    self.nickname = (QEntryElement *)[self.root elementWithKey:@"nickname"];
    self.services = (QLabelElement *)[self.root elementWithKey:@"services"];
    self.nickname.delegate = self;
    QAppearance *qa = [self.nickname.appearance copy];
    qa.entryAlignment = NSTextAlignmentRight;
    self.nickname.appearance = qa;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SWFNavedCenterViewController changeNavBarColor:[UIColor blackColor] nc:self];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadServerData];
}

- (void) loadServerData{
    NSString *cachedNickName = [SWFCachePolicy cacheOutWithFileName:SWFUserNickNameCacheFileName];
    NSString *cachedNumberOfService = [SWFCachePolicy cacheOutWithFileName:SWFUserNumberOfServiceCacheFileName];
    if (cachedNickName != nil){
        self.originalDisplayName = cachedNickName;
        self.nickname.textValue = cachedNickName;
        self.nickname.enabled = NO;
    } else {
        [self loading:YES];
    }
    if (cachedNumberOfService != nil){
        self.services.value = cachedNumberOfService;
    }
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:SWFUserPasswordKeychainContainerName];
    NSString *loginName = [usernamepasswordKVPairs objectForKey:SWFUserNameKeychainItemName];
    self.username.value = loginName;
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if (!self.originalDisplayName)
        {
            SWFGetUserNicknameRequest *dispNameRequest = [[SWFGetUserNicknameRequest alloc] init];
            SWFWrapper *response = [dispNameRequest getUserNickname];
            if ([response isKindOfClass:[SWFWrapper class]])
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    self.originalDisplayName = [response stringValue];
                    self.nickname.textValue = [response stringValue];
                    self.nickname.placeholder = [response stringValue];
                    self.nickname.enabled = YES;
                    [SWFCachePolicy cacheInWithData:[response stringValue] fileName:SWFUserNickNameCacheFileName];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    self.nickname.textValue = NSLocalizedString(@"ui.no-name",
                                                                   @"No name");
                    self.nickname.enabled = NO;
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),^{
                self.nickname.textValue = self.originalDisplayName;
                self.nickname.enabled = YES;
            });
        }
        SWFNumberOfServicesRequest *nosr = [[SWFNumberOfServicesRequest alloc] init];
        SWFWrapper *nosw = [nosr numberOfServices];
        dispatch_async(dispatch_get_main_queue(),^{
            if ([nosw isKindOfClass:[SWFWrapper class]]) {
                self.services.value = [NSString stringWithFormat:NSLocalizedString(@"ui.numServices", @""),[nosw stringValue]];
                [SWFCachePolicy cacheInWithData:self.services.value fileName:SWFUserNumberOfServiceCacheFileName];
            }
        });
        dispatch_async(dispatch_get_main_queue(),^{
            [self.quickDialogTableView reloadData];
            if (cachedNickName == nil){
                [self loading:NO];
            }
        });
    });
}

- (void) QEntryDidEndEditingElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell{
    if(element == self.nickname){
        if (![self.nickname.textValue isEqualToString:self.originalDisplayName] &&
            [self.nickname.textValue length])
        {
            NSString *newName = self.nickname.textValue;
            dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                SWFChangeNicknameRequest *dnUpdate = [[SWFChangeNicknameRequest alloc] init];
                dnUpdate.nn = newName;
                [dnUpdate changeNickname];
                self.originalDisplayName = nil;
                [self loadServerData];
            });
        }
        else
        {
            self.nickname.textValue = self.originalDisplayName;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onServices:(QLabelElement *)buttonElement {
    SWFServicesViewController *svc = [[SWFServicesViewController alloc] initWithNibName:@"SWFServicesViewController" bundle:nil];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)alterPassword:(QLabelElement *)buttonElement {
    SWFAlterPasswordViewController *apvc = [[SWFAlterPasswordViewController alloc] initWithRoot:[[QRootElement alloc] initWithJSONFile:@"alterPassword"]];
    [self.navigationController pushViewController:apvc animated:YES];
}

- (void)onLogout:(QLabelElement *)buttonElement {
    [SWFAppDelegate logout];
}

- (void)onEULA:(QLabelElement *)buttonElement {
    SWFWebBrowserViewController *browser = [[SWFWebBrowserViewController alloc] initWithNibName:@"SWFWebBrowserViewController" bundle:nil];
    [self presentViewController:browser animated:YES completion:nil];
    browser.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    browser.webView.scrollView.bounces = NO;
    browser.webView.scrollView.bouncesZoom = NO;
    [browser.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"EULA" ofType:@"html"]]]];
    
}

- (void)aboutMobile:(QLabelElement *)buttonElement {
    SWFWebBrowserViewController *browser = [[SWFWebBrowserViewController alloc] initWithNibName:@"SWFWebBrowserViewController" bundle:nil];
    [self presentViewController:browser animated:YES completion:nil];
    browser.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    browser.webView.scrollView.bounces = NO;
    browser.webView.scrollView.bouncesZoom = NO;
    [browser.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"aboutMobileWebFusion" ofType:@"html"]]]];
    
}

- (void)rateUS:(QLabelElement *)buttonElement {
    [Appirater rateApp];
}

- (void)contactUS:(QLabelElement *)buttonElement {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[[NSString alloc] initWithFormat:NSLocalizedString(@"ui.aMessageFromUser", @""),self.username.value]];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"shisoftgenius@hotmail.com", @"shisoftgenius@gmail.com", nil];
        [mailer setToRecipients:toRecipients];
        [self presentViewController:mailer animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.thanksForFeedback", @"")];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
