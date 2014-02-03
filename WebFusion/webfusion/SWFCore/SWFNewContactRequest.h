//
//  SWFNewContactRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-21.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFWrapper.h"

@interface SWFNewContactRequest : CGIRemoteObject

@property NSString *address;
@property NSString *displayName;
@property id svr;

@end

@interface SWFNewContactRequest (SWFMethods)

- (SWFWrapper*) newContact;

@end