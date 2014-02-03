//
//  SWFFileUploadByBase64String.h
//  webfusion
//
//  Created by Jack Shi on 13-7-7.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFFileUploadByBase64String : CGIRemoteObject

@property NSString *path;
@property NSData *str;

@end

@interface SWFFileUploadByBase64String (SWFMethods)

- (id)FileUploadByBase64String;

@end