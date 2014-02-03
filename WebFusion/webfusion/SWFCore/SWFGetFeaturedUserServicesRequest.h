//
//  SWFGetFeaturedUserServicesRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-20.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetFeaturedUserServicesRequest : CGIRemoteObject

@property NSString *feature;

@property id ucid;

@end

@interface SWFGetFeaturedUserServicesRequest (SWFMethods)

- (NSArray*) getFeaturedUserServices;

@end