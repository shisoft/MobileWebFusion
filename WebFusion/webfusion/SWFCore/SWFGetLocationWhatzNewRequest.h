//
//  SWFGetLocationWhatzNewRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-15.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetLocationWhatzNewRequest : CGIRemoteObject

@property NSArray *tags;
@property int count;
@property double lat;
@property double lon;
@property int source;

@end

@interface SWFGetLocationWhatzNewRequest (SWFMethods)

- (NSArray *)getLocationWhatzNew;

@end