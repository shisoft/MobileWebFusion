//
//  SWFCombineContactRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-22.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFCombineContactRequest : CGIRemoteObject

@property id oid;
@property id nid;

@end

@interface SWFCombineContactRequest (SWFMethods)

- (void) combineContact;

@end