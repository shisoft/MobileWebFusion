//
//  SWFReportAbuseViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-8-11.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "QuickDialogController.h"
#import "QRadioElement.h"

@interface SWFReportAbuseViewController : QuickDialogController

@property int type;
@property id obj;
@property QRadioElement *category;
@property QEntryElement *comment;

@end
