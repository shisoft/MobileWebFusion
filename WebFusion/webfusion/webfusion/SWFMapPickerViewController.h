//
//  SWFMapPickerViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-6.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SWFTrackedViewController.h"

@interface SWFMapPickerViewController : SWFTrackedViewController
- (IBAction)useMapPressed:(id)sender;
- (IBAction)cancelMapPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *useMapButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UINavigationItem *naviTitle;

@end
