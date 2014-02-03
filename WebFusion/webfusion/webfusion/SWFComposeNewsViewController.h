//
//  SWFComposeNewsViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-5.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SWFTrackedViewController.h"

@interface SWFComposeNewsViewController : SWFTrackedViewController <UIAlertViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property UIToolbar *keyboardToolbar;
@property UIBarButtonItem* blogButton;
@property UIBarButtonItem* imageButton;
@property UIBarButtonItem* locateButton;
@property UIBarButtonItem* checkinButton;
@property UIBarButtonItem* wordCount;
@property NSString* blogTitle;
@property UIImage* photo;
@property UIImagePickerController *imagePicker;
@property CLLocationManager* locationManager;
@property CLLocation* location;
@property BOOL checkIn;
@property BOOL gotLocationName;
@property NSString *checkInInnid;
@property NSURL *animatedImage;

-(void)checkinButtonPressed;
-(void)doCheckIn: (NSString*) innid name:(NSString*) name;

@end
