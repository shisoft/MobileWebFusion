//
//  SWFNewsTrendsRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-27.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFWrapper.h"

@interface SWFNewsTrendsRequest : CGIRemoteObject

@property NSArray *queries;
@property int ita;
@property long long pubStart;
@property long long pubEnd;

@end

@interface SWFNewsTrendsRequest (SWFMethods)

- (SWFWrapper *) newsTrends;

@end
