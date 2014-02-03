//
//  SWFSearchRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-20.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFSearchRequest : CGIRemoteObject

@property NSString *kw;
@property NSString *svr;
@property NSString *types;

@end

@interface SWFSearchRequest (SWFMethods)

- (NSArray*) search;

@end