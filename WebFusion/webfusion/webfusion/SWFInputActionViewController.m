//
//  SWFNewsInputActionViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-9.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFInputActionViewController.h"
#import "SWFQuickReplyRequest.h"
#import "SWFCustomStatusBar.h"
#import "SWFRepostRequest.h"
#import "SWFAddBookmarkRequest.h"
#import "SWFNewPostRequest.h"
#import "SWFRepostThreadRequest.h"

@interface SWFInputActionViewController ()

@end

@implementation SWFInputActionViewController

@synthesize action;
@synthesize newsId;
@synthesize postId;
@synthesize wordCount;
@synthesize keyboardToolbar;
@synthesize textView;

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
    self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.keyboardToolbar.barStyle = UIBarStyleDefault;
    self.keyboardToolbar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    wordCount = [[UIBarButtonItem alloc] initWithTitle:@"0 / 140" style:UIBarButtonItemStylePlain target:nil action:nil];
    [keyboardToolbar setItems:[NSArray arrayWithObjects: flexSpace, wordCount, nil] animated:NO];
    [textView setInputAccessoryView:keyboardToolbar];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    if ([newsId isKindOfClass:[NSString class]]){
        switch (self.action) {
            case 0:
                self.title = NSLocalizedString(@"ui.repost", @"");
                self.textView.text = self.title;
                [self.textView selectAll:self];
                break;
            case 1:
                self.title = NSLocalizedString(@"ui.reply", @"");
                break;
            case 2:
                self.title = NSLocalizedString(@"ui.bookmark", @"");
                break;
            case 3:
                self.title = NSLocalizedString(@"ui.read-later", @"");
                break;
            default:
                break;
        }
    } else if ([postId isKindOfClass:[NSString class]]){
        switch (self.action) {
            case 0:
                self.title = NSLocalizedString(@"ui.reply", @"");
                break;
            case 1:
                self.title = NSLocalizedString(@"ui.repost", @"");
                self.textView.text = self.title;
                [self.textView selectAll:self];
                break;
            case 2:
                self.title = NSLocalizedString(@"ui.bookmark", @"");
                break;
            case 3:
                self.title = NSLocalizedString(@"ui.read-later", @"");
                break;
            default:
                break;
        }
    }
    [self.textView becomeFirstResponder];
    [self countWord];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self countWord];
}

-(void)countWord{
    NSInteger limit = 140;
    NSInteger iwordCount = [[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    NSString *limitText = [NSString stringWithFormat:@"%d",limit];
    
    if(action >= 2 || ([postId isKindOfClass:[NSString class]] && action !=1)){
        limit = NSIntegerMax;
    }
    
    if(limit == NSIntegerMax){
        limitText = @"∞";
    }
    
    self.wordCount.title = [NSString stringWithFormat:@"%d / %@",iwordCount,limitText];
    if(iwordCount > limit || (iwordCount == 0 && action < 2)){
        self.wordCount.tintColor = [UIColor redColor];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.wordCount.tintColor = nil;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonPressed {
        SWFCustomStatusBar *statusBar = [[SWFCustomStatusBar alloc]  initWithFrame:[UIScreen mainScreen].applicationFrame];
        [statusBar showStatusMessage:NSLocalizedString(@"ui.sending", @"")];
    NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([newsId isKindOfClass:[NSString class]]){
            switch (self.action) {
                case 0:
                {
                    SWFRepostRequest *r = [[SWFRepostRequest alloc] init];
                    r.timeoutSeconds = [[NSNumber alloc] initWithInt:30];
                    r.ID = newsId;
                    r.content = content;
                    r.exceptions = @"";
                    r.audience = @"";
                    [r repost];
                    break;
                }
                case 1:
                {
                    SWFQuickReplyRequest *r = [[SWFQuickReplyRequest alloc] init];
                    r.timeoutSeconds = [[NSNumber alloc] initWithInt:30];
                    r.content = content;
                    r.ID = newsId;
                    [r quickReply];
                    break;
                }
                case 2:
                {
                    SWFAddBookmarkRequest *r = [[SWFAddBookmarkRequest alloc] init];
                    r.timeoutSeconds = [[NSNumber alloc] initWithInt:30];
                    r.ID = newsId;
                    r.group = @"";
                    r.note = content;
                    r.later = SWFDefaultFalse;
                    r.svrMark = SWFDefaultTrue;
                    r.type = 0;
                    [r addBookmark];
                    break;
                }
                case 3:
                {
                    SWFAddBookmarkRequest *r = [[SWFAddBookmarkRequest alloc] init];
                    r.timeoutSeconds = [[NSNumber alloc] initWithInt:30];
                    r.ID = newsId;
                    r.group = @"";
                    r.note = content;
                    r.later = SWFDefaultTrue;
                    r.svrMark = SWFDefaultFalse;
                    r.type = 0;
                    [r addBookmark];
                    break;
                }
                default:
                    break;
            }
        } else if ([postId isKindOfClass:[NSString class]]){
            switch (self.action) {
                case 0:
                {
                    SWFNewPostRequest *r = [[SWFNewPostRequest alloc] init];
                    r.base = postId;
                    r.content = content;
                    r.title = @"";
                    [r newPost];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.PostDetailsViewController refresh];
                    });
                    break;
                }
                case 1:
                {
                    SWFRepostThreadRequest *r = [[SWFRepostThreadRequest alloc] init];
                    r.tid = postId;
                    r.content = content;
                    r.exceptions = @"";
                    r.audience = @"";
                    [r repostThread];
                    break;
                }
                case 2:
                {
                    SWFAddBookmarkRequest *r = [[SWFAddBookmarkRequest alloc] init];
                    r.ID = postId;
                    r.group = @"";
                    r.note = content;
                    r.later = SWFDefaultFalse;
                    r.svrMark = SWFDefaultTrue;
                    r.type = 1;
                    [r addBookmark];
                    break;
                }
                case 3:
                {
                    SWFAddBookmarkRequest *r = [[SWFAddBookmarkRequest alloc] init];
                    r.ID = postId;
                    r.group = @"";
                    r.note = content;
                    r.later = SWFDefaultTrue;
                    r.svrMark = SWFDefaultFalse;
                    r.type = 1;
                    [r addBookmark];
                    break;
                }
                default:
                    break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [statusBar hide];
            [statusBar removeFromSuperview];
        });
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
