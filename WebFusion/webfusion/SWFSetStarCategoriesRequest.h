//
// Created by Jack Shi on 24/2/15.
// Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CGIJSONObject/CGICommon.h>


@interface SWFSetStarCategoriesRequest : CGIRemoteObject

@property NSString *cats;

@end

@interface SWFSetStarCategoriesRequest (SWFMethods)

- (SWFWrapper *) setStarCategories;

@end