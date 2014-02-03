//
//  SWFLoginAppeal.m
//  webfusion
//
//  Created by Jack Shi on 13-10-13.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFLoginAppeal.h"

@implementation SWFLoginAppeal

@synthesize vc;

- (id)initWithViewController: (SWFLoginViewController*) _vc{
    self = [super init];
    self.vc = _vc;
    return self;
}

- (UIView *)buildFooterForSection:(QSection *)section andTableView:(QuickDialogTableView *)tableView andIndex:(NSInteger)index{
    if (index == 2) {
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vc.view.frame.size.width, 100)];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, vc.view.frame.size.width, 80)];
        webView.scrollView.bounces = NO;
        webView.delegate = vc;
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
        NSUInteger fontSize = 13;
        NSString *link = @"Shisoft";
        [webView loadHTMLString:[NSString stringWithFormat:@"<html><head></head><body style=\"font-family: sans-serif;font-size:%dpx;\"><center>Copyright © %d %@ <p>%@</p></center></body></html>", fontSize, dateComponents.year,link,NSLocalizedString(@"ui.agreeEULA", @"")]  baseURL:nil];
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = NO;
        [containerView addSubview:webView];
        containerView.center = CGPointMake(vc.view.frame.size.width / 2, 50);
        return  containerView;
    }
    return nil;
}

@end
