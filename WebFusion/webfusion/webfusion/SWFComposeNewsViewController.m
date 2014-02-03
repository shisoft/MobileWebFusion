//
//  SWFComposeNewsViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-5.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFComposeNewsViewController.h"
#import "SWFWrapper.h"
#import "SWFPublishBlogRequest.h"
#import "SWFPublishPhotosRequest.h"
#import "SWFSetStatusRequest.h"
#import "SWFAppDelegate.h"
#import "SWFFileUploadByBase64String.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "UIImage+SWFUtilities.h"
#import "SWFCustomStatusBar.h"
#import "SWFPickLocalPOIViewController.h"
#import "SWFRecordAnimatedViewController.h"

@interface SWFComposeNewsViewController ()

@end

@implementation SWFComposeNewsViewController

@synthesize textView;
@synthesize keyboardToolbar;
@synthesize blogButton;
@synthesize imageButton;
@synthesize locateButton;
@synthesize checkinButton;
@synthesize wordCount;
@synthesize blogTitle;
@synthesize imagePicker;
@synthesize photo;

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
    self.title = NSLocalizedString(@"ui.composeNews", @"");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.keyboardToolbar.barStyle = UIBarStyleDefault;
    self.keyboardToolbar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    blogButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"longText"] style:UIBarButtonItemStyleBordered target:self action:@selector(longTextPressed)];
    imageButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"photo"] style:UIBarButtonItemStyleBordered target:self action:@selector(imageButtonPressed)];
    locateButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"located"] style:UIBarButtonItemStyleBordered target:self action:@selector(locateButtonPressed)];
    checkinButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ui.checkin", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(checkinButtonPressed)];
    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    wordCount = [[UIBarButtonItem alloc] initWithTitle:@"0 / 140" style:UIBarButtonItemStylePlain target:nil action:nil];
    [keyboardToolbar setItems:[NSArray arrayWithObjects: blogButton, imageButton, locateButton,checkinButton, flexSpace, wordCount, nil] animated:NO];
    [textView setInputAccessoryView:keyboardToolbar];
    self.checkIn = NO;
    self.gotLocationName = NO;
    self.blogButton.enabled = NO;
    self.imageButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        bool blog = [[SWFAppDelegate getDefaultInstance] hasFeature:@"CanBoradcastBlog"];
        bool image = ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ||
                      [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) && [[SWFAppDelegate getDefaultInstance] hasFeature:@"CanBoradcastImage"];
        dispatch_async(dispatch_get_main_queue(),^{
            blogButton.enabled = blog;
            imageButton.enabled = image;
        });
    });
    [self countWord];
    [textView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [textView becomeFirstResponder];
}

-(void)longTextPressed{
    if (blogButton.tintColor == [UIColor blueColor]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ui.dismissBlogTitle", @"")
                                                        message:NSLocalizedString(@"ui.dismissBlogTitleDesc", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ui.noThanks", @"") otherButtonTitles:NSLocalizedString(@"ui.ok", @""), nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        alert.tag = 1;
        [alert show];
    }else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ui.setBlogTitle", @"")
                                                        message:NSLocalizedString(@"ui.setBlogTitleDesc", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ui.noThanks", @"")
                                              otherButtonTitles:NSLocalizedString(@"ui.ok", @""), nil];
        // 基本输入框，显示实际输入的内容
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = 0;
        // 取得输入的值
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if(alertView.tag == 0){
        UITextField *tf = [alertView textFieldAtIndex:0];
        NSString* text = tf.text;
        if (buttonIndex == 1 && text.length) {
            blogTitle = text;
            self.title = text;
            blogButton.tintColor = [UIColor blueColor];
        }
    }else if (alertView.tag == 1){
        if (buttonIndex == 1){
            blogTitle = nil;
            self.title =  NSLocalizedString(@"ui.composeNews", @"");
            blogButton.tintColor = nil;
        }
    }
    [self countWord];
    [self.textView becomeFirstResponder];
    
}

-(void)imageButtonPressed{
    
    if(self.imagePicker == nil){
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    }

    if (imageButton.tintColor == [UIColor blueColor]) {
        photo = nil;
        imageButton.tintColor = nil;
    }else{
        UIActionSheet *myActionSheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"ui.addPhoto", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ui.cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ui.camera", @""),
                                      NSLocalizedString(@"ui.picture-lib", @""),NSLocalizedString(@"ui.animatedPic", @""), nil];
        //这样就创建了一个UIActionSheet对象，如果要多加按钮的话在nil前面直接加就行，记得用逗号隔开。
        //下面是显示，注意ActioinSheet是出现在底部的，是附加在当前的View上的，所以我们用showInView方法
        [myActionSheet showInView:self.view];
    }
    [self countWord];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        switch (buttonIndex)
        {
            case 0:
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePicker
                                                  animated:YES
                                                completion:nil];
                break;
            case 1:
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:self.imagePicker
                                                  animated:YES
                                 completion:nil];
                break;
            case 2:
            {
                SWFRecordAnimatedViewController *ravc = [[SWFRecordAnimatedViewController alloc]init];
                ravc.cnvc = self;
                UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:ravc];
                [self presentViewController:nv animated:YES completion:nil];
                break;
            }
            default:
                break;
        }
    }
}

UIImage *photo;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    photo = info[UIImagePickerControllerOriginalImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:self.photo.CGImage
                                     metadata:info[UIImagePickerControllerMediaMetadata]
                              completionBlock:nil];
    }
    
    if (self.photo){
        self.imageButton.tintColor = [UIColor blueColor];
        if ([self.textView.text length] <= 0) {
            self.textView.text = NSLocalizedString(@"ui.photo", @"");
        }
    }
    else
    {
        self.imageButton.tintColor = nil;
    }
    
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}

- (void)locateButtonPressed{
    [self locate];
}

-(void)locate{
    if(locateButton.tintColor == nil){
        if(self.locationManager == nil){
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        }
        [self.locationManager startUpdatingLocation];
        locateButton.tintColor = [UIColor blackColor];
    }else if(checkinButton.tintColor == nil){
        [self.locationManager stopUpdatingLocation];
        self.location = nil;
        self.checkIn = NO;
        locateButton.tintColor = nil;
        checkinButton.tintColor = nil;
    }
}

BOOL locationFailed = NO;

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(locationFailed == NO && self.location == nil){
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ui.locateFailed", @"") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ui.ok", @"") otherButtonTitles:nil, nil] show];
        locateButton.tintColor = nil;
        locationFailed = YES;
        self.checkIn = NO;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    locationFailed = NO;
    self.location = [locations lastObject];
    locateButton.tintColor = [UIColor blueColor];
    if(self.checkIn){
       
    }
}

-(void)doCheckIn: (NSString*) innid name:(NSString*) name{
    self.checkinButton.tintColor = [UIColor blueColor];
    self.checkIn = YES;
    self.checkInInnid = innid;
    [self locate];
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"ui.I'mAt", @""),name];
    UITextRange *range = [self.textView selectedTextRange];
    if (range)
    {
        [self.textView replaceRange:range withText:text];
    }
    else
    {
        self.textView.text = [self.textView.text stringByAppendingString:text];
    }

}

-(void)checkinButtonPressed{
    if(self.checkIn){
        self.checkIn = NO;
        self.checkInInnid = nil;
        self.checkinButton.tintColor = nil;
    }else{
        SWFPickLocalPOIViewController *plpoi = [[SWFPickLocalPOIViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:plpoi];
        [self presentViewController:nc animated:YES completion:nil];
        plpoi.cnc = self;
    }
}


- (void)textViewDidChange:(UITextView *)textView
{
    [self countWord];
}

-(void)countWord{
    NSInteger limit = 140;
    NSInteger iwordCount = [[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    
    if(blogButton.tintColor != nil){
        limit = NSIntegerMax;
    }
    
    NSString *limitText = [NSString stringWithFormat:@"%d",limit];
    
    if(limit == NSIntegerMax){
        limitText = @"∞";
    }
    self.wordCount.title = [NSString stringWithFormat:@"%d / %@",iwordCount,limitText];
    if(iwordCount > limit ||  (iwordCount == 0 && imageButton.tintColor == nil)){
        self.wordCount.tintColor = [UIColor redColor];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.wordCount.tintColor = nil;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         self.textView.contentInset = UIEdgeInsetsMake(self.textView.contentInset.top, 0, [[aNotification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height, 0);
                         self.textView.scrollIndicatorInsets = self.textView.contentInset;
                     }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{

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
    [statusBar showStatusMessage:NSLocalizedString(@"ui.sendingNews", @"")];
    BOOL hasTitle = blogTitle != nil;
    BOOL hasImage = photo != nil;
    BOOL hasLocated = self.location != nil;
    NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageToSend;
        if(hasImage){
            if (self.animatedImage != nil) {
                imageToSend = [[NSData alloc] initWithContentsOfURL:self.animatedImage];
            }else{
                UIImage *_Photo = photo;
                CGSize size = [photo size];
                CGFloat maxImageSize = 400;
                if (MAX(size.height, size.width) > maxImageSize){
                    if (size.width > size.height) {
                        CGFloat origWidth = size.width;
                        size.width = maxImageSize;
                        size.height = size.height * (maxImageSize / origWidth);
                    }else{
                        CGFloat origHeight = size.height;
                        size.height = maxImageSize;
                        size.width = size.width * (maxImageSize / origHeight);
                    }
                    _Photo = [photo scaledImageToSize:CGSizeMake(size.width,size.height)];
                }
                // Get the image in PNG.
                imageToSend = UIImagePNGRepresentation(_Photo);
            }
        }
        if(hasTitle){
            SWFPublishBlogRequest *pbr = [[SWFPublishBlogRequest alloc] init];
            pbr.timeoutSeconds = [[NSNumber alloc] initWithInt:30];
            pbr.title = [blogTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            pbr.content = [NSString stringWithFormat:@"<p>%@</p>",content];
            pbr.exceptions = @"";
            pbr.audience = @"";
            if (hasLocated)
            {
                pbr.lat = self.location.coordinate.latitude;
                pbr.lon = self.location.coordinate.longitude;
                pbr.checkin = (self.checkIn ? SWFDefaultTrue : SWFDefaultFalse);
                pbr.linnid = self.checkInInnid;
                pbr.located = SWFDefaultTrue;
            }
            else
            {
                pbr.located = SWFDefaultFalse;
            }
            if(hasImage){
                double now = [[NSDate date] timeIntervalSince1970];
                NSString *remotePath = [NSString stringWithFormat:@"uploads.share/%f/%f.png",now,now];
                SWFFileUploadByBase64String *imageUploader = [[SWFFileUploadByBase64String alloc] init];
                imageUploader.timeoutSeconds = [[NSNumber alloc] initWithInt:300];
                imageUploader.str = imageToSend;
                imageUploader.path = remotePath;
                [imageUploader FileUploadByBase64String];
                NSString *remoteURL = [NSString stringWithFormat:@"http://www.shisoft.net/GetUserFile?p=%@&user=%@", remotePath, [SWFAppDelegate getDefaultInstance].currentUser];
                pbr.content = [NSString stringWithFormat:@"%@<img src='%@' alt='' ></img>",pbr.content,remoteURL];
            }
            pbr.richText = SWFDefaultFalse;
            [pbr publishBlog];
        }else if (hasImage){
            SWFPublishPhotosRequest *ppr = [[SWFPublishPhotosRequest alloc] init];
            ppr.timeoutSeconds = [[NSNumber alloc] initWithInt:300];
            ppr.content = content;
            ppr.exceptions = @"";
            ppr.audience = @"";
            if (hasLocated)
            {
                ppr.lat = self.location.coordinate.latitude;
                ppr.lon = self.location.coordinate.longitude;
                ppr.checkin = (self.checkIn ? SWFDefaultTrue : SWFDefaultFalse);
                ppr.located = SWFDefaultTrue;
                ppr.linnid = self.checkInInnid;
            }
            else
            {
                ppr.located = SWFDefaultFalse;
            }
            ppr.image = imageToSend;
            ppr.album = NSLocalizedString(@"server.pic-album", @"");
            [ppr publishPhotos];
        }else{
            SWFSetStatusRequest *ssr = [[SWFSetStatusRequest alloc] init];
            ssr.timeoutSeconds = [[NSNumber alloc] initWithInt:30];
            ssr.content = content;
            ssr.exceptions = @"";
            ssr.audience = @"";
            if (hasLocated)
            {
                ssr.lat = self.location.coordinate.latitude;
                ssr.lon = self.location.coordinate.longitude;
                ssr.checkin = (self.checkIn ? SWFDefaultTrue : SWFDefaultFalse);
                ssr.located = SWFDefaultTrue;
                ssr.linnid = self.checkInInnid;
            }
            else
            {
                ssr.located = SWFDefaultFalse;
            }
            ssr.richText = ([content length] > 140) ? SWFDefaultTrue : SWFDefaultFalse;
            [ssr setStatus];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [statusBar hide];
            [statusBar removeFromSuperview];
        });
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
