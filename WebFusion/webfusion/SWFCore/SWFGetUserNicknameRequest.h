//
//  DCGetUserNicknameRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@class SWFWrapper;

@interface SWFGetUserNicknameRequest : CGIRemoteObject

@end

@interface SWFGetUserNicknameRequest (SWFMethods)

- (SWFWrapper *)getUserNickname;

@end
