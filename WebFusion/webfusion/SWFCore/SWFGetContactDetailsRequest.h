//
//  SWFGetContactDetailsRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-19.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFWrapper.h"

@interface SWFGetContactDetailsRequest : CGIRemoteObject

@property id ID;

@end

@interface SWFGetContactDetailsRequest (SWFMethods)

- (SWFWrapper *)getContactDatails;

@end