//
//  SWFComposeTopicViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-14.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFComposeTopicViewController.h"
#import "SWFGetContactsForPostRequest.h"
#import "SWFUserContact.h"
#import <CoreGraphics/CoreGraphics.h>
#import "UIWebView+AccessoryHiding.h"
#import "SWFNewPostRequest.h"
#import "SWFNewPostContact.h"
#import "SWFUniversalContact.h"
#import "SWFCustomStatusBar.h"
#import "SWFWrapper.h"
#import "SWFUserContactPickerViewController.h"

@interface SWFComposeTopicViewController ()
@end

@implementation SWFComposeTopicViewController {
	CGFloat _keyboardHeight;
}

@synthesize _tokenFieldView;
@synthesize contentView;

- (void)viewDidLoad {
	
	[self.view setBackgroundColor:[UIColor whiteColor]];
	[self.navigationItem setTitle:NSLocalizedString(@"ui.composeTopic", @"")];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
	_tokenFieldView = [[TITokenFieldView alloc] initWithFrame:self.view.bounds];
	//[_tokenFieldView setSourceArray:[Names listOfNames]];
	[self.view addSubview:_tokenFieldView];
	
	[_tokenFieldView.tokenField setDelegate:self];
	[_tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldFrameDidChange:) forControlEvents:TITokenFieldControlEventFrameDidChange];
	[_tokenFieldView.tokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@",;."]]; // Default is a comma
    [_tokenFieldView.tokenField setPromptText:NSLocalizedString(@"ui.sendTo", @"")];
	[_tokenFieldView.tokenField setPlaceholder:NSLocalizedString(@"ui.TypeName", @"")];
	
	UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
	[addButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
	[_tokenFieldView.tokenField setRightView:addButton];
	[_tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
	[_tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
    contentView = [[UIWebView alloc] initWithFrame:_tokenFieldView.contentView.bounds];
    NSString *contentHTML =[NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"userTopicInput" withExtension:@"html"] encoding:NSUTF8StringEncoding error:NULL];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [contentView loadHTMLString:contentHTML baseURL:baseURL];
    
    contentView.scrollView.bounces = NO;
    
	[_tokenFieldView.contentView addSubview:contentView.scrollView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	// You can call this on either the view on the field.
	// They both do the same thing.
	[_tokenFieldView becomeFirstResponder];
    
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWFGetContactsForPostRequest *r = [[SWFGetContactsForPostRequest alloc] init];
        NSArray *uca = [r getContactsForPost];
        if ([uca isKindOfClass:[NSArray class]]) {
            self.contactDict = [[NSMutableDictionary alloc] initWithCapacity:[uca count]];
            self.names = [[NSMutableArray alloc] initWithCapacity:[uca count]];
            for (SWFUserContact *uc in uca){
                [self.names addObject:uc.name];
                [self.contactDict setObject:uc forKey:uc.name];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tokenFieldView setSourceArray:self.names];
            });
        }
    });
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{[self resizeViews];}]; // Make it pweeetty.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self resizeViews];
}

- (void)showContactsPicker:(id)sender {
	SWFUserContactPickerViewController *picker = [[SWFUserContactPickerViewController alloc] initWithNibName:@"SWFUserContactPickerViewController" bundle:nil];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:nv animated:YES completion:nil];
    [picker loadContactsFromSource:1 exceptionIDs:nil callback:^(id _uc) {
        SWFUserContact *uc = _uc;
        TIToken * token = [_tokenFieldView.tokenField addTokenWithTitle:uc.name];
        //[token setAccessoryType:TITokenAccessoryTypeDisclosureIndicator];
        [_tokenFieldView.tokenField layoutTokensAnimated:YES];
    } title:NSLocalizedString(@"ui.selectContactForNewPost", @"")];
	// Show some kind of contacts picker in here.
	// For now, here's how to add and customize tokens.
	
	//NSArray * names = [Names listOfNames];
	
	//TIToken * token = [_tokenFieldView.tokenField addTokenWithTitle:[names objectAtIndex:(arc4random() % names.count)]];
	//[token setAccessoryType:TITokenAccessoryTypeDisclosureIndicator];
	// If the size of the token might change, it's a good idea to layout again.
	//[_tokenFieldView.tokenField layoutTokensAnimated:YES];
	
	//NSUInteger tokenCount = _tokenFieldView.tokenField.tokens.count;
	//[token setTintColor:((tokenCount % 3) == 0 ? [TIToken redTintColor] : ((tokenCount % 2) == 0 ? [TIToken greenTintColor] : [TIToken blueTintColor]))];
    //for (NSString *stoken in _tokenFieldView.tokenTitles){
    //    NSLog(stoken);
    //}
}

- (void)keyboardWillShow:(NSNotification *)notification {
	
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	_keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
	[self resizeViews];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	_keyboardHeight = 0;
	[self resizeViews];
}

- (void)resizeViews {
    int tabBarOffset = self.tabBarController == nil ?  0 : self.tabBarController.tabBar.frame.size.height;
	[_tokenFieldView setFrame:((CGRect){_tokenFieldView.frame.origin, {self.view.bounds.size.width, self.view.bounds.size.height + tabBarOffset - _keyboardHeight}})];
	[contentView.scrollView setFrame:_tokenFieldView.contentView.bounds];
}

- (BOOL)tokenField:(TITokenField *)tokenField willRemoveToken:(TIToken *)token {
	return YES;
}

- (BOOL)tokenField:(TITokenField *)tokenField willAddToken:(TIToken *)token{
    for (NSString *name in self.names){
        if ([name isEqualToString:token.title]){
            return YES;
        }
    }
    return NO;
}

- (void)tokenFieldChangedEditing:(TITokenField *)tokenField {
	// There's some kind of annoying bug where UITextFieldViewModeWhile/UnlessEditing doesn't do anything.
	[tokenField setRightViewMode:(tokenField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
}

- (void)tokenFieldFrameDidChange:(TITokenField *)tokenField {
	//[self textViewDidChange:_messageView];
}

- (void)cancel{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)done{
    
    SWFCustomStatusBar *statusBar = [[SWFCustomStatusBar alloc]  initWithFrame:[UIScreen mainScreen].applicationFrame];
    [statusBar showStatusMessage:NSLocalizedString(@"ui.sending", @"")];
    
    NSMutableArray *contacts = [[NSMutableArray alloc] initWithCapacity:[_tokenFieldView.tokenTitles count]];
    
    for (NSString *name in _tokenFieldView.tokenTitles){
        SWFUserContact *c = [self.contactDict objectForKey:name];
        SWFNewPostContact *npc = [[SWFNewPostContact alloc] init];
        npc.userContact = SWFDefaultTrue;
        npc.ucid = c.ID;
        [contacts addObject:npc];
    }
    
    NSString *title = [contentView stringByEvaluatingJavaScriptFromString:@"$('#txThreadTitle').val()"];
    NSString *content = [contentView stringByEvaluatingJavaScriptFromString:@"$('#divContent').html()"];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWFNewPostRequest * r = [[SWFNewPostRequest alloc] init];
        r.title = title;
        r.content = content;
        r.contacts = contacts;
        [r newPost];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.tvc refresh];
            [statusBar hide];
            [statusBar removeFromSuperview];
        });
    });
}

@end
