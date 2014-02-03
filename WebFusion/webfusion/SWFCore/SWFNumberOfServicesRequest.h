//
//  SWFNumberOfServicesRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-23.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFWrapper.h"


@interface SWFNumberOfServicesRequest : CGIRemoteObject

@end

@interface SWFNumberOfServicesRequest (SWFMethods)

- (SWFWrapper *) numberOfServices;

@end