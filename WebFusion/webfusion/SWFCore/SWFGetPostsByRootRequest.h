//
//  SWFGetPostsByRootRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-10-31.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetPostsByRootRequest : CGIRemoteObject

@property id root;
@property int page;

@end

@interface SWFGetPostsByRootRequest (SWFMethods)

- (NSArray*)getPostsByRoot;

@end