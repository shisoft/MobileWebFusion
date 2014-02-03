//
//  SWFUpdateUserContactMethodOrderRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-19.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFUpdateUserContactMethodOrderRequest : CGIRemoteObject

@property id ID;
@property NSArray *ucids;

@end

@interface SWFUpdateUserContactMethodOrderRequest (SWFMethods)

- (void) updateUserContactMethodOrder;

@end