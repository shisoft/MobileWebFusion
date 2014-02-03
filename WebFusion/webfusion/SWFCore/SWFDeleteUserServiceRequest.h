//
//  SWFDeleteUserServiceRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-9-13.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFDeleteUserServiceRequest : CGIRemoteObject

@property id ID;

@end

@interface SWFDeleteUserServiceRequest (SWFMethods)

- (void)deleteUserService;

@end