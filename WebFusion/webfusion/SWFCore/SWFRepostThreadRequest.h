//
//  SWFRepostThreadRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-12.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFRepostThreadRequest : CGIRemoteObject

@property id tid;
@property NSString *exceptions;
@property NSString *content;
@property NSString *audience;

@end

@interface SWFRepostThreadRequest (SWFMethods)

- (SWFWrapper *)repostThread;

@end