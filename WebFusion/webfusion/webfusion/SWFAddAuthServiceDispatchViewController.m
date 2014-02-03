//
//  SWFAddAuthServiceDispatchViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-24.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFAddAuthServiceDispatchViewController.h"

@interface SWFAddAuthServiceDispatchViewController ()

@end

@implementation SWFAddAuthServiceDispatchViewController

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
    self.webView.scrollView.bounces = NO;
    self.title = NSLocalizedString(@"ui.dispatchAuthService", @"");
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.webView loadRequest:self.requestToDispatch];
}

- (void)viewWillDisappear:(BOOL)animated{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.activityIndicator stopAnimating];
}

- (BOOL)webView:(UIWebView *) webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    if([requestString hasPrefix:@"https://www.shisoft.net/cr.html"]){
        NSString *strParameters = [[requestString componentsSeparatedByString:@"?"] objectAtIndex:1];
        NSArray *parameters = [strParameters componentsSeparatedByString:@"&"];
        for (NSString *pam in parameters){
            NSArray *nameAndValue = [pam componentsSeparatedByString:@"="];
            NSString *name = [nameAndValue objectAtIndex:0];
            name = [[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
            if ([self isTokenField:name] && [nameAndValue count] > 1) {
                continue;
            }
            NSString *value = [nameAndValue objectAtIndex:1];
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [self.asvc setAuthCode:value query:strParameters];
            [self.navigationController popViewControllerAnimated:YES];
            return NO;
        }
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

- (BOOL)isTokenField:(NSString*) field{
    NSRange rangeValue = [field rangeOfString:@"token" options:NSCaseInsensitiveSearch];
    return (rangeValue.length > 0);
}

@end
