//
//  SWFAlterPasswordViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-8-1.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFAlterPasswordViewController.h"
#import "SWFChangePasswordRequest.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "SWFWrapper.h"

@interface SWFAlterPasswordViewController ()

@end

@implementation SWFAlterPasswordViewController

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ui.alter", @"") style:UIBarButtonItemStyleDone target:self action:@selector(alterPassword)];
	// Do any additional setup after loading the view.
}

- (void)alterPassword{
    if (![self.theNewPasswordText.textValue isEqualToString:self.repeatPasswordText.textValue]) {
        [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.twoPasswordsNotMatch", @"")];
        return;
    }
    if ([self.theNewPasswordText.textValue length] < 6) {
        [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.passwordLess6Char", @"")];
        return;
    }
    [self loading:YES];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        SWFChangePasswordRequest *cpr = [[SWFChangePasswordRequest alloc] init];
        cpr.np = self.theNewPasswordText.textValue;
        cpr.op = self.orignalPasswordText.textValue;
        SWFWrapper *w = [cpr changePassword];
        dispatch_async(dispatch_get_main_queue(),^{
            [self loading:NO];
            if ([w isKindOfClass:[SWFWrapper class]]) {
                NSString *response = [w stringValue];
                if ([response isEqualToString:@"-"]) {
                    [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"err.wrongPassword", @"")];
                    return;
                }else if ([response isEqualToString:@"+"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        });
    });
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[self.quickDialogTableView cellForElement:self.orignalPasswordText] becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setQuickDialogTableView:(QuickDialogTableView *)quickDialogTableView{
    [super setQuickDialogTableView:quickDialogTableView];
    self.orignalPasswordText = (QEntryElement *)[self.root elementWithKey:@"orignalPasswd"];
    self.theNewPasswordText = (QEntryElement *)[self.root elementWithKey:@"newPasswd"];
    self.repeatPasswordText = (QEntryElement *)[self.root elementWithKey:@"repeatPasswd"];

    QAppearance *qa = [[QAppearance alloc] init];
    qa.entryAlignment = NSTextAlignmentLeft;
    self.orignalPasswordText.appearance = qa;
    self.theNewPasswordText.appearance = qa;
    self.repeatPasswordText.appearance = qa;
}

@end
