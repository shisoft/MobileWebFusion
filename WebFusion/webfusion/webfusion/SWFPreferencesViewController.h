//
//  SWFPreferencesViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-23.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "QuickDialogController.h"
#import <MessageUI/MessageUI.h>

@interface SWFPreferencesViewController : QuickDialogController <QuickDialogEntryElementDelegate,MFMailComposeViewControllerDelegate>

@property QLabelElement *username;
@property QEntryElement *nickname;
@property QLabelElement *services;
@property QBooleanElement *pnsSwitch;
@property QBooleanElement *soundEffects;
@property QBooleanElement *vibration;

@property NSString *originalDisplayName;

- (void)onServices:(QLabelElement *)buttonElement;

@end
