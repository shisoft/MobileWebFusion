//
//  SWFPickLocalPOIViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-8-27.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFPickLocalPOIViewController.h"
#import "SWFGetLocationHotSpotAroundRequest.h"
#import "SWFPOI.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "SWFAddLocationHotSpotRequest.h"

@interface SWFPickLocalPOIViewController ()

@end

@implementation SWFPickLocalPOIViewController



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
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    self.title = NSLocalizedString(@"ui.checkin", @"");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // Do any additional setup after loading the view from its nib.
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)add{
    __block CLPlacemark * plmark = nil;
    __block UIAlertView *alert = [UIAlertView initAlertViewWithTitle: NSLocalizedString(@"ui.newPOI", @"") message:NSLocalizedString(@"ui.newPOIDesc", @"") cancelButtonTitle:NSLocalizedString(@"ui.cancel", @"") otherButtonTitles:[[NSArray alloc] initWithObjects:NSLocalizedString(@"ui.ok", @""), nil] onDismiss:^(int buttonIndex) {
        NSString *name = [alert textFieldAtIndex:0].text;
        if([name length] > 0){
            if(plmark !=nil){
                dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    SWFAddLocationHotSpotRequest *alhsr = [[SWFAddLocationHotSpotRequest alloc] init];
                    alhsr.lat = self.location.coordinate.latitude;
                    alhsr.lon = self.location.coordinate.longitude;
                    alhsr.name = name;
                    alhsr.address = plmark.thoroughfare;
                    alhsr.country = plmark.country;
                    alhsr.city = plmark.locality;
                    alhsr.province = plmark.administrativeArea;
                    alhsr.country = plmark.country;
                    SWFWrapper *sw = [alhsr addLocationHotSpot];
                    if([sw isKindOfClass:[SWFWrapper class]]){
                        NSString *innid = [sw stringValue];
                        dispatch_async(dispatch_get_main_queue(),^{
                            [self doChcekIn:innid name:name];
                        });
                    }
                });
            }else{
                [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.errorOnIdentifyNewPOI", @"")];
            }
        }
    } onCancel:^{
        
    }];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray* placemarks,NSError *error)
     {
         if (placemarks.count >0 )
         {
             plmark = [placemarks objectAtIndex:0];
             if([[alert textFieldAtIndex:0].text length] <= 0){
                 [alert textFieldAtIndex:0].text = plmark.name;
                 [[alert textFieldAtIndex:0] selectAll:nil];
             }
         }else{
             [alert dismissWithClickedButtonIndex:0 animated:YES];
             [UIAlertView alertViewWithTitle:nil message:NSLocalizedString(@"ui.errorOnIdentifyNewPOI", @"")]; 
         }
         NSLog(@"%@",placemarks);
     }];
}

- (void)doChcekIn:(NSString*) innid name:(NSString*)name{
    [self.cnc doCheckIn:innid name:name];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (fabs(newLocation.timestamp.timeIntervalSinceNow) < 3)
    {
        [manager stopUpdatingLocation];
        self.location = newLocation;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            SWFGetLocationHotSpotAroundRequest *glspar = [[SWFGetLocationHotSpotAroundRequest alloc] init];
            glspar.lat = self.location.coordinate.latitude;
            glspar.lon = self.location.coordinate.longitude;
            glspar.count = 30;
            NSArray *arr = [glspar getLocationHotSpotAround];
            if([arr isKindOfClass:[NSArray class]]){
                self.pois = arr;
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.tableView reloadData];
                });
            }
        });
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.pois)
    {
        return self.pois.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (self.pois)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"POI"];
        SWFPOI *poi = [self.pois objectAtIndex:indexPath.row];
        cell.textLabel.text = poi.name;
        CLLocationDistance distance = [self.location distanceFromLocation:poi.location];
        BOOL useKilometer = distance > 1000.0;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2lf %@", useKilometer ? distance / 1000.0 : distance, useKilometer ? NSLocalizedString(@"ui.kilometer", "") : NSLocalizedString(@"ui.meter", "")];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Loading"];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = NSLocalizedString(@"ui.loading", @"");
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block SWFPOI *poi = [self.pois objectAtIndex:indexPath.row];
    __block CLPlacemark * plmark = nil;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    if(!([poi.country length] && [poi.city length] && [poi.address length] && [poi.province length] && [poi.country length]))
    [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray* placemarks,NSError *error)
     {
         if (placemarks.count > 0 )
         {
             dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                 SWFAddLocationHotSpotRequest *alhsr = [[SWFAddLocationHotSpotRequest alloc] init];
                 alhsr.lat = self.location.coordinate.latitude;
                 alhsr.lon = self.location.coordinate.longitude;
                 alhsr.name = poi.name;
                 alhsr.address = [plmark.thoroughfare length] ? plmark.thoroughfare : plmark.name;
                 alhsr.country = plmark.country;
                 alhsr.city = plmark.locality;
                 alhsr.province = plmark.administrativeArea;
                 alhsr.country = plmark.country;
                 [alhsr addLocationHotSpot];
             });
         }
         NSLog(@"%@",placemarks);
     }];
    [self doChcekIn:poi.innid name:poi.name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
