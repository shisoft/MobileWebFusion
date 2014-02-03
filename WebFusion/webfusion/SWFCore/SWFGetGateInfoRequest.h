//
//  SWFGetGateInfoRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-24.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFWrapper.h"

@interface SWFGetGateInfoRequest : CGIRemoteObject

@property NSString *code;

@end


@interface SWFGetGateInfoRequest (SWFMethods)

- (SWFWrapper *) getGateList;

@end