//
//  SWFUserContactPrivateConversationViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-10-31.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFTopicMessageViewController.h"
#import "SWFCodeGenerator.h"
#import "SWFGetPostsByRootRequest.h"
#import "SWFNewPostRequest.h"
#import "SWFGetPostIDForUserContactPrivateConversationRequest.h"
#import "SWFGetPostsFromUserContactPrivateConversationRequest.h"
#import "SWFThreadReplyPoll.h"
#import "SWFWebBrowserViewController.h"

@interface SWFTopicMessageViewController ()

@end

@implementation SWFTopicMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.txMessage becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.txMessage resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startPoll];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopPoll];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentPage = 0;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.webView.scrollView addSubview:self.refreshControl];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardWillShowNotification
             object:nil];
    [nc addObserver:self
           selector:@selector(keyboardWillHide:)
               name:UIKeyboardWillHideNotification
             object:nil];
    [super changeNavBarColor:[[UIColor alloc] initWithRed:30.0 / 255.0 green:113 / 255.0 blue:69.0 / 255.0 alpha:0.5]];
    if([self.navigationController.viewControllers count] > 1){
         self.navigationItem.leftBarButtonItem  = nil;
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
    [self loadPagedPosts];
}

-(void)loadPagedPosts{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *pagedPosts = [self getPostsByPage:self.currentPage+1];
        if ([pagedPosts isKindOfClass:[NSArray class]]) {
            NSString *code = [[NSString alloc] init];
            for (SWFPost *post in pagedPosts) {
                code = [[NSString alloc] initWithFormat:@"%@%@", [SWFCodeGenerator generateForConversationPOST:post], code];
            }
            NSString *tempPath = NSTemporaryDirectory();
            NSString *path = [tempPath stringByAppendingPathComponent:@"dispPostReplies.txt"];
            NSError *err;
            [code writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"prepend('%@')",path]];
                
                [self.refreshControl endRefreshing];
            });
            if ([pagedPosts count] > 0) {
                self.currentPage++;
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }
    });
}

-(void)loadRootedPosts:(SWFPost*) post{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.RootIDToReply = post.ID;
        [self refreshLoadNews:[self getNewestPosts]];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        self.txMessage.placeholder = NSLocalizedString(@"ui.replyToTopic", @"");
    });
    [self startPoll];
}

- (void)loadUserContactPrivateConversation:(SWFUserContact*)uc{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.UserContactID = uc.ID;
        [self refreshLoadNews:[self getNewestPosts]];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        self.txMessage.placeholder = [NSString stringWithFormat: NSLocalizedString(@"ui.sendToReceiver", @""), uc.name];
        [[SWFAppDelegate getDefaultInstance].leftSidebar.quickDialogTableView reloadData];
        if(self.navigationItem.rightBarButtonItem == nil){
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(toUCBar)];
        }
    });
    [self startPoll];
}

- (void) toUCBar{
    [[SWFAppDelegate getDefaultInstance].deckViewController openRightViewAnimated:YES];
}

- (void) refreshLoadNews:(NSArray*) array{
    self.newestPosts = [[NSMutableArray alloc] initWithArray: array];
    dispatch_async(dispatch_get_main_queue(),^{
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [self.webView loadHTMLString:[SWFCodeGenerator generateForConvPostArray:array] baseURL:baseURL];
    });
}

- (NSArray*) getNewestPosts{
    return [self getPostsByPage:0];
}

- (NSArray*) getPostsByPage:(int) page{
    NSArray *r = nil;
    if (self.RootIDToReply != nil) {
        SWFGetPostsByRootRequest *gpbr = [[SWFGetPostsByRootRequest alloc] init];
        gpbr.root = self.RootIDToReply;
        gpbr.page = page;
        r = [gpbr getPostsByRoot];
    }else if (self.UserContactID != nil) {
        SWFGetPostsFromUserContactPrivateConversationRequest *gpfucpc = [[SWFGetPostsFromUserContactPrivateConversationRequest alloc] init];
        gpfucpc.ucid = self.UserContactID;
        gpfucpc.page = page;
        r = [gpfucpc getPostsFromUserContactPrivateConversation];
    }
    if ([r isKindOfClass:[NSArray class]]) {
        return r;
    }else{
        return [[NSArray alloc] init];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length] > 0) {
        [self reply];
        return YES;
    };
    return NO;
}

- (void)reply{
    __block NSString *text = self.txMessage.text;
    self.txMessage.text = @"";
    self.progressbar.hidden = NO;
    [self.progressbar setProgress:0.0 animated:NO];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id rootId = nil;
        if (self.RootIDToReply != nil) {
            rootId = self.RootIDToReply;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressbar setProgress:0.25 animated:YES];
            });
        }else if (self.UserContactID != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressbar setProgress:0.10 animated:YES];
            });
            SWFGetPostIDForUserContactPrivateConversationRequest *gpidfucpc = [[SWFGetPostIDForUserContactPrivateConversationRequest alloc] init];
            gpidfucpc.ucid = self.UserContactID;
            SWFWrapper *w = gpidfucpc.getPostIDForUserContactPrivateConversation;
            if([w isKindOfClass:[SWFWrapper class]]){
                rootId =[w stringValue];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressbar setProgress:0.25 animated:YES];
            });
        }
        if(rootId != nil){
            SWFNewPostRequest *r = [[SWFNewPostRequest alloc] init];
            r.base = rootId;
            r.content = text;
            r.title = @"";
            [r newPost];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressbar setProgress:0.5 animated:YES];
            });
            [self checkNewPosts];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressbar setProgress:1.0 animated:YES];
            });
        }else{
            // popup
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:0.2 animations:^{
                self.progressbar.alpha = 0.0;
            } completion:^(BOOL finished){
                self.progressbar.hidden = YES;
                self.progressbar.alpha = 1.0;
            }];
        });
    });
}

- (void)checkNewPosts{
    NSArray *newests = [self getNewestPosts];
    if ([newests isKindOfClass:[NSArray class]]) {
        NSEnumerator *reveresed = [newests reverseObjectEnumerator];
        SWFPost *loadedNewestPost = [self.newestPosts firstObject];
        for (SWFPost *newPost in reveresed) {
            if (newPost.posttime.timeIntervalSinceReferenceDate > loadedNewestPost.posttime.timeIntervalSinceReferenceDate) {
                [self appendNewPost:newPost];
            }
        }
    }
}

- (void)appendNewPost:(SWFPost*)newPost{
    [self.newestPosts insertObject:newPost atIndex:0];
    NSString *item = [SWFCodeGenerator generateForConversationPOST:newPost];
    NSString *tempPath = NSTemporaryDirectory();
    NSString *path = [tempPath stringByAppendingPathComponent:@"dispPostReplies.txt"];
    NSError *err;
    [item writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"append('%@')",path]];
    });
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         CGRect cFrame = self.composeBar.frame;
                         CGFloat kbHeight = [[aNotification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
                         cFrame.origin.y = self.view.frame.size.height - kbHeight - self.composeBar.frame.size.height;
                         self.composeBar.frame = cFrame;
                         self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.webView.scrollView.contentInset.top, 0, kbHeight + cFrame.size.height, 0);
                         self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset;
                         [self toTail];
                     }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         CGRect cFrame = self.composeBar.frame;
                         cFrame.origin.y = self.view.frame.size.height - self.composeBar.frame.size.height;
                         self.composeBar.frame = cFrame;
                         self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.webView.scrollView.contentInset.top, 0, cFrame.size.height, 0);
                         self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset;
                     }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (!self.progressbar) {
        NSLog(@"%f", self.webView.scrollView.contentInset.top);
        self.progressbar = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.webView.scrollView.contentInset.top, 320, 2)];
        self.progressbar.tintColor = [[UIColor alloc] initWithRed:30 / 255.0 green:113 / 255.0 blue:69 / 255.0 alpha:1.0];
        self.progressbar.hidden = YES;
        [self.view addSubview: self.progressbar];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        SWFWebBrowserViewController *browser = [[SWFWebBrowserViewController alloc] initWithNibName:@"SWFWebBrowserViewController" bundle:nil];
        [self presentViewController:browser animated:YES completion:nil];
        [browser.webView loadRequest:request];
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",[error localizedDescription]);
}

- (void)toTail{
    [self.webView stringByEvaluatingJavaScriptFromString:@"toTail()"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startPoll{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SWFPoll defaultPoll] addDelegate:self forKey:@"thcon"];
        [[SWFPoll defaultPoll] repoll];
    });
}

-(void)stopPoll{
    [[SWFPoll defaultPoll] removeKey:@"thcon"];
    [[SWFPoll defaultPoll] repoll];
}

- (id)poll:(SWFPoll *)poll objectForKey:(NSString *)key
{
    if(YES){
        id rootId = nil;
        if (self.RootIDToReply != nil) {
            rootId = self.RootIDToReply;
        }else if (self.UserContactID != nil) {
            SWFGetPostIDForUserContactPrivateConversationRequest *gpidfucpc = [[SWFGetPostIDForUserContactPrivateConversationRequest alloc] init];
            gpidfucpc.ucid = self.UserContactID;
            SWFWrapper *w = gpidfucpc.getPostIDForUserContactPrivateConversation;
            if([w isKindOfClass:[SWFWrapper class]]){
                rootId =[w stringValue];
            }
        }
        if (rootId) {
            SWFThreadReplyPoll *poll = [[SWFThreadReplyPoll alloc] init];
            poll.ID = rootId;
            return poll;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

- (void)poll:(SWFPoll *)poll receivedObject:(id)object forKey:(NSString *)key
{
    if ([object isKindOfClass:[NSArray class]])
    {
        NSArray *newPosts = object;
        for (NSDictionary *p in newPosts) {
            if ([p isKindOfClass:[NSDictionary class]]) {
                SWFPost *post = [[SWFPost alloc] initWithPersistanceObject:p[@"p"]];
                if ([post isKindOfClass:[SWFPost class]]) {
                    dispatch_async(dispatch_get_main_queue(),^{
                        [self appendNewPost:post];
                    });
                }
            }
        }
    }
}


@end
