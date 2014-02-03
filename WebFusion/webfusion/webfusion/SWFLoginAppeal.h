//
//  SWFLoginAppeal.h
//  webfusion
//
//  Created by Jack Shi on 13-10-13.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFDefAppeal.h"
#import "QuickDialog.h"
#import "QSection.h"
#import "SWFLoginViewController.h"

@interface SWFLoginAppeal : SWFDefAppeal

- (UIView *)buildFooterForSection:(QSection *)section andTableView:(QuickDialogTableView *)tableView andIndex:(NSInteger)index;

- (id)initWithViewController: (SWFLoginViewController*) vc;

@property SWFLoginViewController *vc;

@end
