//
//  SWFGetContactSuggestionsRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-22.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFGetContactSuggestionsRequest : CGIRemoteObject

@property NSString *key;

@end

@interface SWFGetContactSuggestionsRequest (SWFMethods)

- (NSArray*) getContactSuggestions;

@end