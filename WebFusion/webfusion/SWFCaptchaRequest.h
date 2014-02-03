//
//  SWFCaptchaRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-8-2.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFCaptchaRequest : CGIRemoteObject

@end

@interface SWFCaptchaRequest (SWFMethods)

- (NSData *) captcha;

@end