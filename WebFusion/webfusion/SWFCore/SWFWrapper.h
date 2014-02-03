//
//  SWFWrapper.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

NSString *const SWFDefaultTrue;
NSString *const SWFDefaultFalse;

@interface SWFWrapper : CGIPersistantObject

@property id d;

@end

@interface SWFWrapper (SWFAccessorMethods)

- (NSString *)stringValue;
- (BOOL)boolValue;
- (id)objectValueWithClass:(Class)class;

@end
