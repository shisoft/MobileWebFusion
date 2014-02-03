//
//  SWFGetUserContactWhatzNewRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-8-12.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetUserContactWhatzNewRequest : CGIRemoteObject

@property int count;
@property id ID;
@property NSDate *lastT;

@end

@interface SWFGetUserContactWhatzNewRequest (SWFMethods)

- (NSArray *)getUserContactWhatzNew;

@end
