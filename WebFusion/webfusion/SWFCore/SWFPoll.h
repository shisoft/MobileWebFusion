//
//  SWFPoll.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CGIJSONObject/CGIJSONObject.h>

@class SWFPoll;

@protocol SWFPollDelegate <NSObject>

@required
- (id)poll:(SWFPoll *)poll objectForKey:(NSString *)key;
- (void)poll:(SWFPoll *)poll receivedObject:(id)object forKey:(NSString *)key;

@end

@interface SWFPoll : NSObject

@property NSTimeInterval interval;
@property NSTimeInterval wait;

+ (instancetype)defaultPoll;

- (void)addDelegate:(id<SWFPollDelegate>)delegate forKey:(NSString *)key;
- (void)removeDelegate:(id<SWFPollDelegate>)delegate;
- (void)removeKey:(NSString *)key;

- (void)start;
- (void)stop;
- (void)repoll;

@end
