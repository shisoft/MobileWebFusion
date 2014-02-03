//
//  SWFFinishServiceAuthRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-24.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFFinishServiceAuthRequest : CGIRemoteObject

@property NSString *hash;
@property NSString *svr;
@property NSString *obj;

@end

@interface SWFFinishServiceAuthRequest (SWFMethods)

- (SWFWrapper *) finishServiceAuth;

@end