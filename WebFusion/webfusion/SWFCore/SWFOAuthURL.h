//
//  SWFOAuthURL.h
//  webfusion
//
//  Created by Jack Shi on 13-7-24.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFOAuthURL : CGIPersistantObject

@property NSURL *url;
@property NSString *token;
@property NSString *scret;

@end
