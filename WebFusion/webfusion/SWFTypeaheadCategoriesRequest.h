//
// Created by Jack Shi on 24/2/15.
// Copyright (c) 2015 Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CGIJSONObject/CGICommon.h>


@interface SWFTypeaheadCategoriesRequest : CGIRemoteObject

@property NSString *types;

@end

@interface SWFTypeaheadCategoriesRequest (SWFMethod)

- (NSArray *) typeaheadCategories;

@end