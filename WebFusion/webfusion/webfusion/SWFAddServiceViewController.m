//
//  SWFAddServiceViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-23.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFAddServiceViewController.h"
#import "SWFGate.h"
#import "SWFGetGateListRequest.h"
#import "SWFGetGateInfoRequest.h"
#import "SWFGateInfo.h"
#import "SWFStartServiceAuthRequest.h"
#import "SWFOAuthURL.h"
#import "SWFAddAuthServiceDispatchViewController.h"
#import "SWFFinishServiceAuthRequest.h"
#import "SWFOAuthTestAccessPack.h"
#import "SWFWriteNewServiceRequest.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "SWFLoadingHUD.h"


@interface SWFAddServiceViewController ()

@end

@implementation SWFAddServiceViewController

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
    self.navigationController.navigationBar.translucent = NO;
    self.title = NSLocalizedString(@"ui.addService", @"");
    [self loadGateList];
    [self initializeWebView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    // Do any additional setup after loading the view from its nib.
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    SWFGate *gate = [self.gates objectAtIndex:[self.servicePickerView selectedRowInComponent:0]];
    NSString *key = [self.webView stringByEvaluatingJavaScriptFromString:@"getServiceKey()"];
    NSString *code = gate.code;
    MBHUDView *hud =[MBHUDView hudWithBody:NSLocalizedString(@"ui.LoggingServices", @"") type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0 show:YES];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        SWFWriteNewServiceRequest *wnr = [[SWFWriteNewServiceRequest alloc] init];
        wnr.key = key;
        wnr.code = code;
        wnr.timeoutSeconds = [[NSNumber alloc] initWithInt:30];
        SWFWrapper *w = [wnr writeNewService];
        dispatch_async(dispatch_get_main_queue(),^{
            [hud dismiss];
            if ([w isKindOfClass:[SWFWrapper class]]) {
                NSString *r = [w stringValue];
                if ([r isEqualToString:@"true"]) {
                    [[SWFAppDelegate getDefaultInstance].userFeatures removeAllObjects];
                    [self.userServiceListView loadServicesAsync];
                    [MBHUDView hudWithBody:NSLocalizedString(@"ui.serviceAddedPleaseWait", @"") type:MBAlertViewHUDTypeActivityIndicator hidesAfter:5.0 show:YES].uponDismissalBlock = ^{
                        [self dismiss];
                    };
                    return;
                }
            }
            [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.addServiceFailed", @"") cancelButtonTitle:NSLocalizedString(@"ui.ok", @"")];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        });
    });
}

- (void)initializeWebView{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *html = [NSMutableString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"addService" withExtension:@"html"] encoding:NSUTF8StringEncoding error:NULL];
    self.webView.scrollView.bounces = NO;
    [self.webView loadHTMLString:html baseURL:baseURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadGateList{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        SWFGetGateListRequest *r = [[SWFGetGateListRequest alloc] init];
        self.gates = [r getGateList];
        if ([self.gates isKindOfClass:[NSArray class]]) {
            dispatch_async(dispatch_get_main_queue(),^{
                [self.servicePickerView reloadAllComponents];
            });
        }else{
            self.gates = nil;
        }
    });
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    @try {
        NSUInteger count = [self.gates count];
        return (count ? count : 1);
    }
    @catch (NSException *exception) {
        return 0;
    }
}

- (UIView*) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    SWFGate *gate = [self.gates objectAtIndex:row];
    
    NSString *svrExpLocalizeKey = [NSString stringWithFormat:@"svr.%@",gate.code];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 150, 32)];
    firstLabel.text = NSLocalizedString(svrExpLocalizeKey, @"");
    firstLabel.textAlignment = NSTextAlignmentLeft;
    firstLabel.backgroundColor = [UIColor clearColor];
    
    //UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 0, 60, 32)];
    //secondLabel.text = [array2 objectAtIndex:row];
    //secondLabel.textAlignment = UITextAlignmentLeft;
    //secondLabel.backgroundColor = [UIColor clearColor];
    
    UIImage *img = [UIImage imageNamed:gate.code];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:img];
    icon.frame = CGRectMake(10, 0, 30, 30);
    
    if (![self.gates count]) {
        firstLabel.text = NSLocalizedString(@"ui.loading", @"");
    }
    
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 32)];
    [tmpView insertSubview:icon atIndex:0];
    [tmpView insertSubview:firstLabel atIndex:0];
    //[tmpView insertSubview:secondLabel atIndex:0];
    [tmpView setUserInteractionEnabled:NO];
    [tmpView setTag:row];
    return tmpView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self loadAddHTML];
}



- (BOOL)webView:(UIWebView *) webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    SWFGate *gate = [self.gates objectAtIndex:[self.servicePickerView selectedRowInComponent:0]];
    if([requestString hasPrefix:@"file://"] || [requestString hasPrefix:@"about:"]){
        return YES;
    } else if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"swf"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"startAuth"]){
            //gotAuthURL(path)
            SWFLoadingHUD *lhud = [[SWFLoadingHUD alloc] initWithBody:nil];
            dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                @try {
                    SWFStartServiceAuthRequest *ssar = [[SWFStartServiceAuthRequest alloc] init];
                    ssar.svr = gate.code;
                    ssar.hash = [NSString stringWithFormat:@"%d",arc4random()];
                    self.randomHash = ssar.hash;
                    SWFWrapper *w = [ssar startServiceAuth];
                    SWFOAuthURL *ourl = [w objectValueWithClass:[SWFOAuthURL class]];
                    NSString *code = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:[ourl persistaceObject] options:0 error:nil] encoding:NSUTF8StringEncoding];
                    NSString *tempPath = NSTemporaryDirectory();
                    NSString *path = [tempPath stringByAppendingPathComponent:@"oauthUrl.txt"];
                    NSError *err;
                    [code writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
                    dispatch_async(dispatch_get_main_queue(),^{
                        [lhud dismiss];
                        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"gotAuthURL('%@')",path]];
                    });
                }
                @catch (NSException *exception) {
                    dispatch_async(dispatch_get_main_queue(),^{
                        [lhud dismiss];
                        [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.errorOnGetAuthURL", @"")];
                      });
                }
            });
        } else if ([(NSString *)[components objectAtIndex:1] isEqualToString:@"done"]){
            [self done];
        } else if ([requestString hasPrefix:@"swf://"]){
            SWFLoadingHUD *lhud = [[SWFLoadingHUD alloc] initWithBody:nil];
            NSString *json = [self decodeFromPercentEscapeString:[requestString stringByReplacingOccurrencesOfString:@"swf://" withString:@""]];
            dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                @try {
                    SWFFinishServiceAuthRequest *fsar = [[SWFFinishServiceAuthRequest alloc] init];
                    fsar.hash = self.randomHash;
                    fsar.svr = gate.code;
                    fsar.obj = json;
                    SWFWrapper *w = [fsar finishServiceAuth];
                    SWFOAuthTestAccessPack *otap = [w objectValueWithClass:[SWFOAuthTestAccessPack class]];
                    if (![otap isKindOfClass:[SWFOAuthTestAccessPack class]]) {
                        dispatch_async(dispatch_get_main_queue(),^{
                            [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.addServiceFailed", @"") cancelButtonTitle:NSLocalizedString(@"ui.ok", @"")];
                            [lhud dismiss];
                        });
                        return;
                    }
                    NSString *code = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:[otap persistaceObject] options:0 error:nil] encoding:NSUTF8StringEncoding];
                    NSString *tempPath = NSTemporaryDirectory();
                    NSString *path = [tempPath stringByAppendingPathComponent:@"finishAuthTestAccessPack.txt"];
                    NSError *err;
                    [code writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
                    dispatch_async(dispatch_get_main_queue(),^{
                        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"authSuccess('%@')",path]];
                        [lhud dismiss];
                    });

                }
                @catch (NSException *exception) {
                    dispatch_async(dispatch_get_main_queue(),^{
                        [lhud dismiss];
                        [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.errorOnGetAuthURL", @"")];
                    });
                }
            });
        }else{
            NSLog(@"Others: %@",requestString);
        }
    }else{
        // OAuth Dispatch
        SWFAddAuthServiceDispatchViewController *avc = [[SWFAddAuthServiceDispatchViewController alloc] initWithNibName:@"SWFAddAuthServiceDispatchViewController" bundle:nil];
        avc.asvc = self;
        avc.requestToDispatch = request;
        [self.navigationController pushViewController:avc animated:YES];
    }
    return NO;
}

- (NSString*) decodeFromPercentEscapeString:(NSString *) string {
    return (__bridge NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                         (__bridge CFStringRef) string,
                                                                                         CFSTR(""),
                                                                                         kCFStringEncodingUTF8);
}

- (void)loadAddHTML{
    SWFLoadingHUD *lhud = [[SWFLoadingHUD alloc] initWithBody:nil];
    SWFGate *gate = [self.gates objectAtIndex:[self.servicePickerView selectedRowInComponent:0]];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        @try {
            SWFGetGateInfoRequest *r = [[SWFGetGateInfoRequest alloc] init];
            r.code = gate.code;
            SWFGateInfo *info = [[r getGateList] objectValueWithClass:[SWFGateInfo class]];
            NSString *code = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:[info persistaceObject] options:0 error:nil] encoding:NSUTF8StringEncoding];
            NSString *tempPath = NSTemporaryDirectory();
            NSString *path = [tempPath stringByAppendingPathComponent:@"addService.txt"];
            NSError *err;
            [code writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
            dispatch_async(dispatch_get_main_queue(),^{
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadServiceAddHTML('%@')",path]];
                [lhud dismiss];
            });
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(),^{
                [self loadAddHTML];
                [lhud dismiss];
            });
        }
    });
}

- (void)setAuthCode:(NSString*)code query:(NSString*)query{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"SetCode(\"%@\",\"%@\")",code,query]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self loadAddHTML];
}


@end
