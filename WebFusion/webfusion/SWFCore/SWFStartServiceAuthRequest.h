//
//  SWFStartServiceAuthRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-24.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFStartServiceAuthRequest : CGIRemoteObject

@property NSString *hash;
@property NSString *svr;

@end

@interface SWFStartServiceAuthRequest (SWFMethods)

- (SWFWrapper *) startServiceAuth;

@end