//
//  SWFNewsTrendsRequest.m
//  webfusion
//
//  Created by Jack Shi on 13-7-27.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFNewsTrendsRequest.h"
#import "SWFWrapper.h"

@implementation SWFNewsTrendsRequest

CGIPersistanceKeyClass(queries, NSString);
CGIRemoteMethodClass(newsTrends, SWFWrapper);

@end
