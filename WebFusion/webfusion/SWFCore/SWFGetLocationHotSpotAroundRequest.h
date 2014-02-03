//
//  SWFGetLocationHotSpotAroundRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-8-28.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetLocationHotSpotAroundRequest : CGIRemoteObject

@property double lat;
@property double lon;
@property int count;

@end

@interface SWFGetLocationHotSpotAroundRequest (SWFMethods)

- (NSArray *)getLocationHotSpotAround;

@end
