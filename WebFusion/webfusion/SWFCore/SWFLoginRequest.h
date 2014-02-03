//
//  DCLoginRequest.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@class SWFWrapper;

@interface SWFLoginRequest : CGIRemoteObject

@property NSString *user;
@property NSString *pass;

@end

@interface SWFLoginRequest (SWFMethods)

- (SWFWrapper *)login;

@end
