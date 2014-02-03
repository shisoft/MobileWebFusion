//
//  SWFRegisterViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-8-2.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "QuickDialogController.h"
#import "QEntryElement.h"
#import "QAppearance.h"

@interface SWFRegisterViewController : QuickDialogController

@property QEntryElement *username;
@property QEntryElement *nickname;
@property QEntryElement *password;
@property QEntryElement *repeatPassword;
@property QEntryElement *captcha;
@property (atomic) UIImageView *captchaImageView;

- (void) getCaptchaImage;

@end
