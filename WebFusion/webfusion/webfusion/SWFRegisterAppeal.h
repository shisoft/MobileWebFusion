//
//  SWFRegisterAppeal.h
//  webfusion
//
//  Created by Jack Shi on 13-10-12.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "QAppearance.h"
#import "SWFRegisterViewController.h"
#import "SWFDefAppeal.h"

@interface SWFRegisterAppeal : SWFDefAppeal

@property SWFRegisterViewController *regvc;

- (void)cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath;

- (SWFRegisterAppeal*) initWithRegisterViewController:(SWFRegisterViewController *)rvc;

@end
