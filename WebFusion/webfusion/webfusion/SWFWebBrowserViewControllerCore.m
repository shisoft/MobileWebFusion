//
//  SWFWebBrowserViewControllerCore.m
//  webfusion
//
//  Created by Jack Shi on 13-7-7.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFWebBrowserViewControllerCore.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "SWFUIModifiers.h"

@interface SWFWebBrowserViewControllerCore ()

@end

@implementation SWFWebBrowserViewControllerCore

UIActionSheet *actionSheet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = NSLocalizedString(@"ui.loading", @"");
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed)];
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"ui.cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ui.openInSafari", @""),NSLocalizedString(@"ui.copyLink", @""), nil];
    }
    return self;
}

// Add this Method
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [self.webView loadHTMLString:@"<html></html>" baseURL:nil];
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SWFUIModifiers manualBottomTabBarInsetsFor:self.webView.scrollView];
}


-(void) viewWillDisappear:(BOOL)animated{
    actionSheet = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateButtons{
    self.buttonBack.enabled = self.webView.canGoBack;
    self.buttonForward.enabled = self.webView.canGoForward;
    self.buttonReolad.enabled = YES;
}

- (void)cancelButtonPressed {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionButtonPressed {
    [actionSheet showInView:self.view];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.webView goBack];
}

- (IBAction)forwardButtonPressed:(id)sender {
    [self.webView goForward];
}

- (IBAction)reloadButtonPressed:(id)sender {
    [self.webView reload];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [[UIApplication sharedApplication] openURL:self.webView.request.mainDocumentURL];
    }else if (buttonIndex==1){
        @try {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:[self.webView.request.mainDocumentURL absoluteString]];
        }
        @catch (NSException *exception) {
            [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"err.cannotToCopyClipboard", @"")];
        }
    }
}

// MARK: -
// MARK: UIWebViewDelegate protocol
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    self.navigationItem.rightBarButtonItem.enabled = ![requestString hasPrefix:@"file://"];
    self.navigationItem.title = [[request URL] absoluteString];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}


@end
