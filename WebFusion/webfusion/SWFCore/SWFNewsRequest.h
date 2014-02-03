//
//  SWFNewsRequest.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFNewsRequest : CGIRemoteObject

@property NSUInteger count;
@property NSDate *lastT;
@property NSString *type;
@property NSString *exceptions;

@end

@interface SWFNewsRequest (SWFMethods)

- (NSArray *)getWhatzNew;

@end
