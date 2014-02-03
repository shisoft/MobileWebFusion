//
//  CLLocation+CGIPersistance.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CGIJSONObject/CGIJSONObject.h>

extern NSString *const CGILocationLatitudeKey;
extern NSString *const CGILocationLongitudeKey;

@interface CLLocation (CGIPersistance) <CGIPersistantObject>

@end
