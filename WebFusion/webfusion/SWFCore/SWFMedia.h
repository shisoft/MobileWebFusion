//
//  DCMedia.h
//  Deuterium
//
//  Created by John Shi on 13-5-22.
//  Copyright (c) 2013年 muski & Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFMedia : CGIPersistantObject

CGIIdentifierProperty;
@property NSURL *href;
@property NSString *type;
@property NSString *title;
@property NSURL *picThumbnail;
@property NSString *player;
@property NSString *catalog;

@end
