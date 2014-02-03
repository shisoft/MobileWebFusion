//
//  SWFRegisterAppeal.m
//  webfusion
//
//  Created by Jack Shi on 13-10-12.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFRegisterAppeal.h"
#import "QElement+Appearance.h"

@implementation SWFRegisterAppeal

- (SWFRegisterAppeal*) initWithRegisterViewController:(SWFRegisterViewController *)rvc{
    self = [super init];
    self.regvc = rvc;
    return self;
}

- (void)cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 1) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 100, 25)];
        imgView.center = CGPointMake(cell.contentView.bounds.size.width/2,cell.contentView.bounds.size.height/2);
        [cell addSubview:imgView];
        self.regvc.captchaImageView = imgView;
        [self.regvc getCaptchaImage];
        UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [refreshButton setBackgroundImage:[UIImage imageNamed:@"reload"] forState:UIControlStateNormal];
        cell.accessoryView = refreshButton;
        [refreshButton addTarget:self.regvc action:@selector(getCaptchaImage) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
