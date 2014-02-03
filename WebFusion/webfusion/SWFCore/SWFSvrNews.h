//
//  SWFSvrNews.h
//  webfusion
//
//  Created by Jack Shi on 13-7-10.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>
#import "SWFUserServices.h"

@interface SWFSvrNews : CGIPersistantObject

@property NSString *svr;
@property NSString *svrId;
@property SWFUserServices *us;

@end
