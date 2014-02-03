//
//  SWFNewContactByUCIDRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-21.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFWrapper.h"

@interface SWFNewContactByUCIDRequest : CGIRemoteObject

@property NSString *displayName;
@property id svr;
@property id ucid;

@end

@interface SWFNewContactByUCIDRequest (SWFMethods)

- (SWFWrapper*) newContactByUCID;

@end