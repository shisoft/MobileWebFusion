//
//  SWFUserContactRequest.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-30.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFUserContactRequest : CGIRemoteObject

@property NSString *query;
@property NSString *group;
@property NSUInteger page;

@end

@interface SWFUserContactRequest (SWFMethods)

- (NSArray *)getContactNames;

@end
