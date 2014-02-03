//
//  SWFReportAbuseViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-8-11.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFReportAbuseViewController.h"
#import "SWFReportAbuseRequest.h"
#import "UIAlertView+MKBlockAdditions.h"

@interface SWFReportAbuseViewController ()

@end

@implementation SWFReportAbuseViewController

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(report)];
	// Do any additional setup after loading the view.
}

- (void) setQuickDialogTableView:(QuickDialogTableView *)quickDialogTableView{
    [super setQuickDialogTableView:quickDialogTableView];
    self.category = (QRadioElement *)[self.root elementWithKey:@"reason"];
    self.comment = (QEntryElement *)[self.root elementWithKey:@"comment"];
}


- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)report{
    [self loading:YES];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        SWFReportAbuseRequest *rar = [[SWFReportAbuseRequest alloc] init];
        rar.comment = self.comment.textValue;
        rar.obj = self.obj;
        rar.type = self.type;
        rar.category = self.category.selected;
        SWFWrapper *sw = [rar reportAbuse];
        if([sw isKindOfClass:[SWFWrapper class]]){
            dispatch_async(dispatch_get_main_queue(),^{
                if ([sw boolValue]) {
                    [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.reportAbuseSucceed", @"")];
                }else{
                    [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.reportAbuseFailed", @"")];
                }
            });
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [self loading:NO];
            [self dismiss];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
