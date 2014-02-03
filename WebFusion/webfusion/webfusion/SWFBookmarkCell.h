//
//  SWFBookmarkCell.h
//  webfusion
//
//  Created by Jack Shi on 13-7-25.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFBookmarkCellViewController.h"

@class SWFBookmarkCellViewController;

@interface SWFBookmarkCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel *publishLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bookmarkTypeIcon;
@property SWFBookmarkCellViewController *bookmarkCellViewController;

@end
