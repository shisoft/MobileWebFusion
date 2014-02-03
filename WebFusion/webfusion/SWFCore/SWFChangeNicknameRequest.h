//
//  DCChangeNicknameRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFChangeNicknameRequest : CGIRemoteObject

@property NSString *nn;

@end

@interface SWFChangeNicknameRequest (SWFMethods)

- (id *)changeNickname;

@end