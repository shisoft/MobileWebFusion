//
//  SWFGetGateListRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-23.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetGateListRequest : CGIRemoteObject

@end

@interface SWFGetGateListRequest (SWFMethods)

- (NSArray *) getGateList;

@end