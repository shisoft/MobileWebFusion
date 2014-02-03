//
//  SWFRecordAnimatedViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-9-17.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFRecordAnimatedViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SWFLoadingHUD.h"
#import "UIImage+animatedGIF.h"

@interface SWFRecordAnimatedViewController ()

@end

@implementation SWFRecordAnimatedViewController

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.title = NSLocalizedString(@"ui.animatedPic", @"");
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!self.viewDidLoaded){
        [self cameraButtonPressed:nil];
        self.viewDidLoaded=YES;
    }
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done{
    self.cnvc.imageButton.tintColor = [UIColor blueColor];
    self.cnvc.photo = self.previewImage.image;
    self.cnvc.animatedImage = self.gifURL;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraButtonPressed:(id)sender {
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissModalViewControllerAnimated: YES];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}


// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    [self dismissModalViewControllerAnimated:NO];
    
    [self.savingHUD dismiss];
    
    self.savingHUD = [[SWFLoadingHUD alloc] initWithBody:NSLocalizedString(@"ui.savingVideo", @"")];
    
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        NSString *moviePath = [[info objectForKey:
                                UIImagePickerControllerMediaURL] path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (moviePath,self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

- (void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    [self.savingHUD dismiss];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"ui.failedSavingVideo", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ui.ok", @"") otherButtonTitles: nil, nil];
        [alert show];
    }else{
        SWFLoadingHUD *processingHud = [[SWFLoadingHUD alloc] initWithBody:NSLocalizedString(@"ui.analyzingVideo", @"")];
        NSURL *videoURL = [[NSURL alloc] initFileURLWithPath:videoPath];
        self.previewImage.image = [self thumbnailImageForVideo:videoURL atTime:0];
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        [options setValue:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:videoURL options:options];
        NSMutableArray *thumbTimes=[NSMutableArray arrayWithCapacity:asset.duration.value];
        int step = asset.duration.value / 50;
        for (int i = 0; i < asset.duration.value; i += step) {
            CMTime thumbTime = CMTimeMake(i, asset.duration.timescale);
            NSValue *v=[NSValue valueWithCMTime:thumbTime];
            [thumbTimes addObject:v];
        }
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        imageGenerator.appliesPreferredTrackTransform=TRUE;
        imageGenerator.requestedTimeToleranceAfter=kCMTimeZero;
        imageGenerator.requestedTimeToleranceBefore=kCMTimeZero;
        NSURL *documentsDirectoryURL = [[NSURL alloc] initFileURLWithPath:NSTemporaryDirectory()];
        NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat: @"%f.gif",CACurrentMediaTime()]];
        NSDictionary *fileProperties = @{
                                         (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                 (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                                 }
                                         };
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, thumbTimes.count, NULL);
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
        __block int currentFrame = 0;
        AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
        {
            @autoreleasepool
            {
                currentFrame++;
                if (result != AVAssetImageGeneratorSucceeded) {
                    NSLog(@"couldn't generate thumbnail, error:%@", error);
                     NSLog(@"actual time: %lld/%d (requested: %lld/%d)",actualTime.value,actualTime.timescale,requestedTime.value,requestedTime.timescale);
                }else{
                    NSLog(@"actual time: %lld/%d (requested: %lld/%d)",actualTime.value,actualTime.timescale,requestedTime.value,requestedTime.timescale);
                    
                    NSDictionary *frameProperties = @{
                                                      (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                              (__bridge id)kCGImagePropertyGIFDelayTime: @(1.0f / actualTime.timescale * step), // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                                              }
                                                      };
                    
                    //__block UIImage *previewUIImage = [UIImage imageWithCGImage:im];
                    
                    CGImageDestinationAddImage(destination, im, (__bridge CFDictionaryRef)frameProperties);
                    
                    //your image view
                    dispatch_async(dispatch_get_main_queue(),^{
                        @try {
                            //self.previewImage.image = previewUIImage;
                        }
                        @catch (NSException *exception) {
                            self.previewImage.image = nil;
                        }
                        @finally {
                            
                        }
                    });
                }
                if (currentFrame == thumbTimes.count) {
                    if (!CGImageDestinationFinalize(destination)) {
                        NSLog(@"failed to finalize image destination");
                        dispatch_async(dispatch_get_main_queue(),^{
                        });
                    }else{
                        NSLog(@"url=%@", fileURL);
                        self.gifURL = fileURL;
                        dispatch_async(dispatch_get_main_queue(),^{
                            self.previewImage.image = [UIImage animatedImageWithAnimatedGIFURL:fileURL];
                            self.navigationItem.rightBarButtonItem.enabled = YES;
                        });
                    }
                    CFRelease(destination);
                    dispatch_async(dispatch_get_main_queue(),^{
                        [processingHud dismiss];
                    });
                }
            }
        };
        CGSize maxSize = CGSizeMake(300, 300);
        imageGenerator.maximumSize = maxSize;
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        [imageGenerator generateCGImagesAsynchronouslyForTimes:thumbTimes completionHandler:handler];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

@end
