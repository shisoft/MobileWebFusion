//
//  SWFRegisterRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-8-2.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFRegisterRequest : CGIRemoteObject

@property NSString *user;
@property NSString *name;
@property NSString *pass;
@property NSString *captcha;
@property NSString *avatar;

@end

@interface SWFRegisterRequest (SWFMethods)

- (SWFWrapper *) register;

@end