//
//  SWFPlacesViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-15.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFPlacesViewController.h"
#import "SWFGetLocationWhatzNewRequest.h"
#import "JPSThumbnailAnnotation.h"
#import "SWFNews.h"
#import "SWFAvatarHelper.h"
#import "SWFUniversalContact.h"
#import "SWFCodeGenerator.h"
#import "SWFComposeNewsViewController.h"
#import "SWFSingleNewsViewController.h"
#import <MapKit/MapKit.h>

@interface SWFPlacesViewController ()

@end

@implementation SWFPlacesViewController

@synthesize trackButton;
@synthesize annotationCount;
@synthesize annotationIds;
@synthesize annotations;
@synthesize busy;
@synthesize selAnnotation;
@synthesize sourceSegmentControl;
@synthesize currentSource;

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
    busy = NO;
    annotationCount = 20;
    annotations = [[NSMutableArray alloc] initWithCapacity:annotationCount];
    annotationIds = [[NSMutableArray alloc] initWithCapacity:annotationCount];
    self.title = NSLocalizedString(@"func.map", @"");
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.mapType = 0;
    trackButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    sourceSegmentControl = [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:NSLocalizedString(@"ui.fromAll", @""),NSLocalizedString(@"ui.fromContact", @""),NSLocalizedString(@"ui.fromMe", @""), nil]];
    sourceSegmentControl.segmentedControlStyle = UISegmentedControlStyleBar; 
    sourceSegmentControl.selectedSegmentIndex = 0;
    [sourceSegmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:sourceSegmentControl];
    [self.bottomBar setItems:[NSArray arrayWithObjects: segButton,flexSpace, trackButton, nil] animated:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [super changeNavBarColor:[[UIColor alloc] initWithRed:163.0 / 255 green:188 / 255.0 blue:58 / 255.0 alpha:1.0]];
    // Do any additional setup after loading the view from its nib.
}
     
-(void)segmentAction:(UISegmentedControl *)Seg{
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger index = Seg.selectedSegmentIndex;
            if (index != currentSource){
                busy = NO;
                [annotationIds removeAllObjects];
                [annotations removeAllObjects];
                selAnnotation = nil;
                [self.mapView removeAnnotations:self.mapView.annotations];
                [self refresh];
            }
        });
    });
}

-(void) viewWillDisappear:(BOOL)animated{
    trackButton.enabled = NO;
    self.mapView.showsUserLocation = NO;
}

- (void) dealloc{
    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = nil;
    [self.mapView removeFromSuperview];
    self.mapView = nil;
}

- (void) viewWillAppear:(BOOL)animated{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        bool canSend = [[SWFAppDelegate getDefaultInstance] hasFeature:@"CanBoradcast,CanBoradcastImage,CanBoradcastBlog"];
        dispatch_async(dispatch_get_main_queue(),^{
            self.navigationItem.rightBarButtonItem.enabled = canSend;
        });
    });
    self.mapView.showsUserLocation = YES;
    trackButton.enabled = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) compose{
    SWFComposeNewsViewController *cnvc = [[SWFComposeNewsViewController alloc] initWithNibName:@"SWFComposeNewsViewController" bundle:nil];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cnvc];
    [self presentViewController:nvc animated:YES completion:^{
        [cnvc checkinButtonPressed];
    }];
}

- (void) refresh{
    if (busy){
        return;
    }
    currentSource = sourceSegmentControl.selectedSegmentIndex;
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        busy = YES;
        SWFGetLocationWhatzNewRequest *r = [[SWFGetLocationWhatzNewRequest alloc] init];
        r.count = 10;
        r.lat = self.mapView.centerCoordinate.latitude;
        r.lon = self.mapView.centerCoordinate.longitude;
        r.source = currentSource;
        NSArray *ra = [r getLocationWhatzNew];
        if(![ra isKindOfClass:[NSArray class]]){
            return;
        }
        NSMutableArray *_annos = [[NSMutableArray alloc] initWithCapacity:[ra count]];        
        for (SWFNews *news in ra){
            if (currentSource != r.source) {
                return;
            }
            if ([annotationIds containsObject:news.ID]){
                continue;
            }
            JPSThumbnail *tumbnail = [[JPSThumbnail alloc] init];
            tumbnail.title = [SWFCodeGenerator authorDescription:news.authorUC];
            tumbnail.subtitle = news.title;
            tumbnail.coordinate = news.location.coordinate;
            tumbnail.disclosureBlock = ^{
                SWFSingleNewsViewController *snvc = [[SWFSingleNewsViewController alloc] initWithNibName:@"SWFSingleNewsViewController" bundle:nil];
                UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:snvc];                snvc.news = news;
                [self presentViewController:nvc animated:YES completion:^{
                    snvc.title = news.title;
                }];
            };
            if([annotations count] >= annotationCount){
                JPSThumbnailAnnotation *anno = [annotations objectAtIndex:0];
                [annotationIds removeObjectAtIndex:[annotations indexOfObject:anno]];
                [annotations removeObject:anno];
                [self.mapView removeAnnotation: anno];
            }
            JPSThumbnailAnnotation *anno = [[JPSThumbnailAnnotation alloc] initWithThumbnail:tumbnail];
            [annotations addObject:anno];
            [annotationIds addObject:news.ID];
            tumbnail.image = [SWFAvatarHelper displayAvatar:news.authorUC.avatar callback:^(id img){
                tumbnail.image = img;
                [anno updateImage:img];
            }];
            [anno updateImage:tumbnail.image];
            [_annos addObject:anno];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotations:_annos];
        });
        busy = NO;
    });
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //[self refresh];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
        selAnnotation = view.annotation;
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
        selAnnotation = nil;
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        [self refresh];
    }
}

- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if(!selAnnotation){
        [self refresh];
    }
}

@end
