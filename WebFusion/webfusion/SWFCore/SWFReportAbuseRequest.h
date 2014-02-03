//
//  SWFReportAbuseRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-8-11.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFReportAbuseRequest : CGIRemoteObject

@property id obj;
@property int type;
@property int category;
@property NSString *comment;

@end

@interface SWFReportAbuseRequest (SWFMethods)

- (SWFWrapper *) reportAbuse;

@end
