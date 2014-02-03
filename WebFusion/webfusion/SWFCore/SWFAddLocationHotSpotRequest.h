//
//  SWFAddLocationHotSpotRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-8-28.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFAddLocationHotSpotRequest : CGIRemoteObject

@property double lat;
@property double lon;
@property NSString *name;
@property NSString *address;
@property NSString *locationClass;
@property NSString *country;
@property NSString *city;
@property NSString *province;

@end

@interface SWFAddLocationHotSpotRequest (SWFMethods)

- (SWFWrapper *)addLocationHotSpot;

@end