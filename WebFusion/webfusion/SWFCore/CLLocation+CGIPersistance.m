//
//  CLLocation+CGIPersistance.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import "CLLocation+CGIPersistance.h"

NSString *const CGILocationLatitudeKey = @"lat";
NSString *const CGILocationLongitudeKey = @"lon";

@implementation CLLocation (CGIPersistance)

- (id)initWithPersistanceObject:(id)persistance
{
    if ([persistance isKindOfClass:[NSDictionary class]])
    {
        @try
        {
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [persistance[CGILocationLatitudeKey] doubleValue];
            coordinate.longitude = [persistance[CGILocationLongitudeKey] doubleValue];
            return [self initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        }
        @catch (NSException *exception)
        {
            return persistance;
        }
    }
    else
        return persistance;
}

- (id)persistaceObject
{
    return @{
             CGILocationLongitudeKey: @(self.coordinate.longitude),
             CGILocationLatitudeKey: @(self.coordinate.latitude)
             };
}

@end
