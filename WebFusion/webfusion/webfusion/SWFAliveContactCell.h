//
//  SWFAliveContactCell.h
//  webfusion
//
//  Created by Jack Shi on 13-10-29.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWFAliveContactCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *serviceImageView;
@property (strong, nonatomic) IBOutlet UILabel *serviceAccounrLabel;

@property BOOL loaded;

- (void)drawShadow;

@end
