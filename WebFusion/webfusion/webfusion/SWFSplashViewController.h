//
//  SWFSplashViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-6-29.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFTrackedViewController.h"

@interface SWFSplashViewController : SWFTrackedViewController

- (IBAction)buttonLoginPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UILabel *labelLogging;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;

- (void)rotateLogoDown1;
- (void)rotateLogoDown2;

@end
