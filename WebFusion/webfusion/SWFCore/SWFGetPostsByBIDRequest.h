//
//  SWFGetPostsByBIDRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-12.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetPostsByBIDRequest : CGIRemoteObject

@property id bid;
@property int page;

@end

@interface SWFGetPostsByBIDRequest (SWFMethods)

- (NSArray*)getPostsByBID;

@end