//
//  SWFAliveContactCell.m
//  webfusion
//
//  Created by Jack Shi on 13-10-29.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFAliveContactCell.h"
#import <QuartzCore/CALayer.h>

@implementation SWFAliveContactCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)drawShadow{
    self.avatarImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.avatarImageView.layer.shadowOffset = CGSizeMake(0, 0);
    self.avatarImageView.layer.shadowOpacity = 1;
    self.avatarImageView.layer.shadowRadius = 1.5;
    self.avatarImageView.clipsToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
