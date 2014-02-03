//
//  SWFRecordAnimatedViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-9-17.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFComposeNewsViewController.h"
#import "SWFLoadingHUD.h"
#import "SWFTrackedViewController.h"

@interface SWFRecordAnimatedViewController : SWFTrackedViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage;
@property SWFComposeNewsViewController *cnvc;

@property NSURL *gifURL;

@property SWFLoadingHUD *savingHUD;

@property BOOL viewDidLoaded;

- (IBAction)cameraButtonPressed:(id)sender;

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate;
- (void)video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo:(void*)contextInfo;

@end
