//
//  SWFUITopicCell.h
//  webfusion
//
//  Created by Jack Shi on 13-7-9.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFTopicCellViewController.h"
#import <UIKit/UIKit.h>
#import "SWFPost.h"
#import "MSRoundedRectButton.h"

@class SWFTopicCellViewController;

typedef void (^openMSGC)(void);

@interface SWFUITopicCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *publishLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet MSRoundedRectButton *threadsLabel;
@property SWFTopicCellViewController *vc;
@property (nonatomic, strong) openMSGC openMSGC;

-(void) setCellViewController:(SWFTopicCellViewController*) vc;

@end
