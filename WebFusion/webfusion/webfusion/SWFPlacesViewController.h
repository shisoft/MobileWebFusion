//
//  SWFPlacesViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-15.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JPSThumbnailAnnotation.h"
#import "SWFNavedCenterViewController.h"

@interface SWFPlacesViewController :  SWFNavedCenterViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomBar;

@property MKUserTrackingBarButtonItem *trackButton;

@property (strong, atomic) NSMutableArray *annotations;
@property (strong, atomic) NSMutableArray *annotationIds;
@property (atomic) BOOL busy;
@property int annotationCount;
@property JPSThumbnailAnnotation* selAnnotation;
@property int currentSource;

@property UISegmentedControl *sourceSegmentControl;

@end
