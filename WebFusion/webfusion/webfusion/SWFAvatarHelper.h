//
//  SWFAvatarHelper.h
//  webfusion
//
//  Created by Jack Shi on 13-7-15.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWFAvatarHelper : NSObject

+(UIImage*) displayAvatar : (NSURL*) avatarURL callback: (void (^)(id))callback;
+(UIImage*) displayAvatar : (NSURL*) avatarURL callback: (void (^)(id))callback roundCorner : (BOOL) roundCorner;
+(UIImage*) displayAvatar : (NSURL*) avatarURL callback: (void (^)(id))callback roundCorner : (BOOL) roundCorner size : (CGSize) size;

@end
