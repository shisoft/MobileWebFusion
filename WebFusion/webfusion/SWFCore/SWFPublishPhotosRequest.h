//
//  DCPublishPhotosRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import <CoreLocation/CoreLocation.h>

@interface SWFPublishPhotosRequest : CGIRemoteObject

@property NSString *content;
@property NSString *exceptions;
@property NSString *audience;
@property NSString *album;
@property NSData *image;
@property NSString *path;  //Server path (use when 'image' is empty)
@property NSString *linnid; //use for POI in places
@property CLLocationDegrees lat;
@property CLLocationDegrees lon;
@property NSString *located;
@property NSString *checkin;

@end

@interface SWFPublishPhotosRequest (SWFMethods)

- (id)publishPhotos;

@end