//
//  SWFBookmarkCellViewController.h
//  webfusion
//
//  Created by Jack Shi on 13-7-25.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWFBookmarkWrapper.h"
#import "SWFBookmarkCell.h"

@class SWFBookmarkCell;

@interface SWFBookmarkCellViewController : NSObject

@property NSURL *avatar;
@property UIImage *avatarImage;
@property NSString *displayname;
@property NSString *title;
@property UIImage *type;
@property NSDate *publish;
@property NSString *comment;

-(SWFBookmarkCellViewController*)initWithBookmarkWrapper:(SWFBookmarkWrapper *)bw;
-(void)displayInCell:(SWFBookmarkCell*)cell;

@end
