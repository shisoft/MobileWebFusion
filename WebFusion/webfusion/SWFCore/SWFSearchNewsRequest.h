//
//  SWFSearchNewsRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-26.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFSearchNewsRequest : CGIRemoteObject

@property NSString *author;
@property NSString *content;
@property NSString *kw;
@property NSString *lang;
@property NSString *location;
@property int page;
@property NSString *svr;
@property NSString *title;
@property NSString *type;
@property NSString *publish;
@property NSString *poii;

@end

@interface SWFSearchNewsRequest (SWFMethods)

- (NSArray *) searchNews;

@end
