//
//  SWFUITopicCell.m
//  webfusion
//
//  Created by Jack Shi on 13-7-9.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFUITopicCell.h"
#import "SWFCodeGenerator.h"
#import "NSString+SWFUtilities.h"
#import "UIImage+SWFUtilities.h"
#import "SWFAppDelegate.h"

@implementation SWFUITopicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) didMoveToSuperview{
    [self.threadsLabel setHitTestEdgeInsets:UIEdgeInsetsMake(-30, -30, -30, -30)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pressedMSGC:(id)sender {
    if(self.openMSGC){
        self.openMSGC();
    }
}

-(void) setCellViewController : (SWFTopicCellViewController *) vc{
    vc.cell = self;
    self.vc = vc;
    self.authorLabel.text  = vc.author;
    self.publishLabel.text = [SWFCodeGenerator timeDescription:vc.publish];
    self.titleLabel.text = vc.title;
    self.contentLabel.text = vc.content;
    self.openMSGC = vc.openMSGC;
    [self.threadsLabel setTitle:vc.threads forState:UIControlStateNormal];
    self.threadsLabel.hidden = ([vc.post.reply intValue] <= 0);
    [self.vc displayAvatar];
}

@end
