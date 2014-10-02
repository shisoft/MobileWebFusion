//
//  SWFLeftSideBarAppeal.m
//  webfusion
//
//  Created by Jack Shi on 13-10-12.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFLeftSideBarAppeal.h"
#import "QElement.h"
#import "QElement+Appearance.h"
#import "UIImage+SWFUtilities.h"
#import "QBadgeTableCell.h"

@implementation SWFLeftSideBarAppeal

- (void)cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        element.enabled = NO;
        cell.userInteractionEnabled = NO;
        return;
    }
    UIImage *selectedPatternImage = [UIImage imageNamed:@"tweed"];
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor colorWithPatternImage:selectedPatternImage];
    cell.imageView.highlightedImage = [cell.imageView.image maskedImageColor:[UIColor whiteColor]];
    cell.selectedBackgroundView = selectedView;
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    if ([cell isKindOfClass:[QBadgeTableCell class]]) {
        QBadgeTableCell *badgeCell = (QBadgeTableCell*) cell;
        QBadgeElement *badgeElement = (QBadgeElement*) element;
        //badgeCell.left_margin = 30;
        badgeCell.badgeLabel.text = badgeElement.badge;
    }
}


@end
