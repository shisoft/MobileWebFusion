//
//  SWFGetAliveUserContactsRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-10-28.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetAliveUserContactsRequest : CGIRemoteObject

@end

@interface SWFGetAliveUserContactsRequest (SWFMethods)

- (NSArray *) getAliveUserContacts;

@end