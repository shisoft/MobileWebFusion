//
//  SWFPickLocalPOIViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-8-27.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFComposeNewsViewController.h"
#import "SWFTrackedViewController.h"

@interface SWFPickLocalPOIViewController : SWFTrackedViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (atomic, strong) NSArray *pois;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;
@property SWFComposeNewsViewController *cnc;
@property CLPlacemark *plmark;

@end
