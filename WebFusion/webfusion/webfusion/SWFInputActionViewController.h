//
//  SWFNewsInputActionViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-9.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWFPostDetailsViewController.h"
#import "SWFTrackedViewController.h"

@interface SWFInputActionViewController : SWFTrackedViewController<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property int action;
@property id newsId;
@property id postId;

@property UIToolbar *keyboardToolbar;
@property UIBarButtonItem* wordCount;

@property SWFPostDetailsViewController *PostDetailsViewController;

@end
