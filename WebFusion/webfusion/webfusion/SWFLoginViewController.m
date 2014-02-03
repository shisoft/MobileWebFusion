//
//  SWFLoginViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-6-29.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFLoginViewController.h"
#import "SWFLoginRequest.h"
#import "SWFWrapper.h"
#import "CHKeychain.h"
#import "SWFRegisterViewController.h"
#import "SWFWebBrowserViewController.h"
#import "SWFLoginAppeal.h"

@interface SWFLoginViewController ()

@end

@implementation SWFLoginViewController

- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView {
    [super setQuickDialogTableView:aQuickDialogTableView];
    self.quickDialogTableView.bounces = NO;
    self.root.appearance = [[SWFLoginAppeal alloc] initWithViewController:self];   //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:SWFUserPasswordKeychainContainerName];
    NSString *loginName = [usernamepasswordKVPairs objectForKey:SWFUserNameKeychainItemName];
    ((QEntryElement *)[self.root elementWithKey:@"username"]).textValue = loginName;
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        SWFWebBrowserViewController *browser = [[SWFWebBrowserViewController alloc] initWithNibName:@"SWFWebBrowserViewController" bundle:nil];
        [self presentViewController:browser animated:YES completion:nil];
        browser.webView.dataDetectorTypes = UIDataDetectorTypeNone;
        browser.webView.scrollView.bounces = NO;
        browser.webView.scrollView.bouncesZoom = NO;
        [browser.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"EULA" ofType:@"html"]]]];
        return NO;
    }
    return YES;
}

- (void)cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)QEntryShouldChangeCharactersInRangeForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Should change characters");
    return YES;
}

- (void)QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Editing changed");
}


- (void)QEntryMustReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Must return");
}

- (void)onRegister:(QButtonElement *)buttonElement {
    SWFRegisterViewController *rvc =[[SWFRegisterViewController alloc] initWithRoot:[[QRootElement alloc] initWithJSONFile:@"register"]];
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)onLogin:(QButtonElement *)buttonElement {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    __block SWFLoginRequest *login = [[SWFLoginRequest alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:login];
    __block SWFAppDelegate *defAppDelegate = [SWFAppDelegate getDefaultInstance];
    dispatch_group_async(defAppDelegate.SWFBackgroundTasks ,
                         dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                             if ([login.user length] && [login.pass length])
                             {
                                 dispatch_async(dispatch_get_main_queue(),^{
                                                    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
                                                    [usernamepasswordKVPairs setObject:login.user forKey:SWFUserNameKeychainItemName];
                                                    [usernamepasswordKVPairs setObject:login.pass forKey:SWFUserPasswordKeychainItemName];
                                                    [CHKeychain save:SWFUserPasswordKeychainContainerName data:usernamepasswordKVPairs];
                                                    [self dismissViewControllerAnimated:YES
                                                                             completion:nil];
                                                });
                             }
                             else
                             {
                                 defAppDelegate.connected = NO;
                                 dispatch_async(dispatch_get_main_queue(),^{
                                                    [self.view becomeFirstResponder];
                                                });
                             }
                         });

}

@end
