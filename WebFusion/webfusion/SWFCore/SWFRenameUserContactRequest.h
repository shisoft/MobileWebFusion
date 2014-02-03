//
//  SWFRenameUserContactRequest.h
//  webfusion
//
//  Created by Jack Shi on 13-7-22.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface SWFRenameUserContactRequest : CGIRemoteObject

@property NSString *name;
@property id ID;

@end

@interface SWFRenameUserContactRequest (SWFMethods)

- (void) renameUserContact;

@end