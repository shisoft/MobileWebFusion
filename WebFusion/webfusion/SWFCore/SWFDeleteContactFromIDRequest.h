//
//  SWFDeleteContactFromIDRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-19.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFDeleteContactFromIDRequest : CGIRemoteObject

@property id cid;
@property id ucid;

@end

@interface SWFDeleteContactFromIDRequest (SWFMethods)

- (void) deleteContactFromID;

@end