//
//  SWFLoadingHUD.h
//  webfusion
//
//  Created by Jack Shi on 13-9-4.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBHUDView.h"

@interface SWFLoadingHUD : NSObject

@property MBAlertView *hudView;
@property bool done;

- (SWFLoadingHUD *) initWithBody: (NSString*) body;
- (void)dismiss;

@end
