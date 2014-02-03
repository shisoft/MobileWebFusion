//
//  SWFRegisterViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-8-2.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFRegisterViewController.h"
#import "SWFCaptchaRequest.h"
#import "UIImage+SWFUtilities.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "SWFRegisterRequest.h"
#import "CHKeychain.h"
#import "QuickDialogController+Loading.h"
#import "QButtonElement.h"
#import "QEntryElement.h"
#import "QEntryTableViewCell.h"
#import "QTextField.h"
#import "QElement+Appearance.h"
#import "SWFRegisterAppeal.h"

@interface SWFRegisterViewController ()

@end

@implementation SWFRegisterViewController

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
    self.title = NSLocalizedString(@"ui.register",@"");
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setQuickDialogTableView:(QuickDialogTableView *)quickDialogTableView{
    [super setQuickDialogTableView:quickDialogTableView];
    self.root.appearance = [[SWFRegisterAppeal alloc] initWithRegisterViewController:self];
    self.username = (QEntryElement *)[self.root elementWithKey:@"username"];
    self.nickname = (QEntryElement *)[self.root elementWithKey:@"nickname"];
    
    self.password =  (QEntryElement *)[self.root elementWithKey:@"password"];
    self.repeatPassword = (QEntryElement *)[self.root elementWithKey:@"repeatPasswd"];
    self.captcha =   (QEntryElement *)[self.root elementWithKey:@"captcha"];
    self.captcha.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
}

- (void) getCaptchaImage{
    [self loading:YES];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSURLRequest *request = [NSURLRequest requestWithURL: [[NSURL alloc] initWithString:@"https://www.shisoft.net/ajax/Captcha"]];
        NSData *chaData = [NSURLConnection sendSynchronousRequest:request
                                                returningResponse:nil
                                                            error:NULL];
        UIImage *img = [[[UIImage alloc] initWithData:chaData] roundedImageWithRadius:10];
        dispatch_async(dispatch_get_main_queue(),^{
            self.captchaImageView.image = img;
            [self loading:NO];
        });
    });
}

- (void)onRegister:(QButtonElement *)buttonElement {
   [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    NSArray *cells = [self cellsForTableView:self.quickDialogTableView];
    for (UITableViewCell *cell in cells) {
        if ([cell isKindOfClass:[QEntryTableViewCell class]]) {
            QEntryTableViewCell *tcell = (QEntryTableViewCell*) cell;
            if ([tcell.textField.text length] <= 0) {
                [UIAlertView alertViewWithTitle:nil message:[NSString stringWithFormat:NSLocalizedString(@"ui.pleaseInput", @""), cell.textLabel.text]];
                return;
            }
        }
    }
    if (![self.password.textValue isEqualToString:self.repeatPassword.textValue]) {
        [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.twoPasswordsNotMatch", nil)];
        return;
    }
    if ([self.password.textValue length] < 6) {
        [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.passwordLess6Char", @"")];
        return;
    }
    [self loading:YES];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        SWFRegisterRequest *rr = [[SWFRegisterRequest alloc] init];
        rr.user = self.username.textValue;
        rr.name = self.nickname.textValue;
        rr.pass = self.password.textValue;
        rr.captcha = self.captcha.textValue;
        SWFWrapper *w = [rr register];
        dispatch_async(dispatch_get_main_queue(),^{
            @try {
                if ([w isKindOfClass:[SWFWrapper class]]) {
                    NSString *r = [w stringValue];
                    if ([r isEqualToString:@"VICError"]) {
                        [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.wrongCaptcha", @"")];
                    }else if ([r isEqualToString:@"Exists"]){
                        [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.usernameExists", @"")];
                    }else if ([r isEqualToString:@"-"]){
                        [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.generalError", @"")];
                    }else if ([r isEqualToString:@"+"]){
                        @try {
                            
                            NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
                            [usernamepasswordKVPairs setObject:self.username.textValue forKey:SWFUserNameKeychainItemName];
                            [usernamepasswordKVPairs setObject:self.password.textValue forKey:SWFUserPasswordKeychainItemName];
                            [CHKeychain save:SWFUserPasswordKeychainContainerName data:usernamepasswordKVPairs];
                            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                        }
                        @catch (NSException *exception) {
                            [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.generalError", @"")];
                        }
                        @finally {
                            
                        }
                    }
                    
                }else{
                    [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.generalError", @"")];
                }
            }
            @catch (NSException *exception) {
                [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.generalError", @"")];
            }
            @finally {
                
            }
            [self loading:NO];
        });
    });
}

-(NSArray *)cellsForTableView:(UITableView *)tableView
{
    NSInteger sections = tableView.numberOfSections;
    NSMutableArray *cells = [[NSMutableArray alloc]  init];
    for (int section = 0; section < sections; section++) {
        NSInteger rows =  [tableView numberOfRowsInSection:section];
        for (int row = 0; row < rows; row++) {
            @try {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                [cells addObject:[tableView cellForRowAtIndexPath:indexPath]];
            }
            @catch (NSException *exception) {
                
            }
        }
    }
    return cells;
}

- (BOOL) shouldAutorotate{
    return NO;
}

@end
