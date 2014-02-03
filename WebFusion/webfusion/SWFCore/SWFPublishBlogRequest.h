//
//  DCPublishBlogRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import <CoreLocation/CoreLocation.h>

@interface SWFPublishBlogRequest : CGIRemoteObject

@property NSString *title;
@property NSString *content;
@property NSString *exceptions;
@property NSString *audience;
@property CLLocationDegrees lat;
@property CLLocationDegrees lon;
@property NSString *located;
@property NSString *richText;
@property NSString *checkin;
@property NSString *linnid;

@end

@interface SWFPublishBlogRequest (SWFMethods)

- (id)publishBlog;

@end