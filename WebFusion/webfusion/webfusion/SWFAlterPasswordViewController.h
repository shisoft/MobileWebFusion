//
//  SWFAlterPasswordViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-8-1.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "QuickDialogController.h"

@interface SWFAlterPasswordViewController : QuickDialogController

@property QEntryElement *orignalPasswordText;
@property QEntryElement *theNewPasswordText;
@property QEntryElement *repeatPasswordText;

@end
