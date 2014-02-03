//
//  SWFWriteNewServiceRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-24.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFWriteNewServiceRequest : CGIRemoteObject

@property NSString *code;
@property NSString *key;

@end

@interface SWFWriteNewServiceRequest (SWFMethods)

- (SWFWrapper *) writeNewService;

@end