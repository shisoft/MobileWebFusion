//
// Created by Jack Shi on 24/2/15.
// Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SWFGetStarCategoriesRequest : CGIRemoteObject
@end

@interface SWFGetStarCategoriesRequest (SWFMethods)

- (NSArray *) getStarCategories;

@end