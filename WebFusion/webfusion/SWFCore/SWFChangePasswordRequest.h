//
//  SWFChangePasswordRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-8-2.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFChangePasswordRequest : CGIRemoteObject

@property NSString *np;
@property NSString *op;

@end

@interface SWFChangePasswordRequest (SWFMethods)

- (SWFWrapper *) changePassword;

@end