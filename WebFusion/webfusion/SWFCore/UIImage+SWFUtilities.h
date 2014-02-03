//
//  UIImage+SWFUtilities.h
//  webfusion
//
//  Created by Jack Shi on 13-7-2.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DCUtilities)

- (UIImage *)scaledImageToSize:(CGSize)newSize;
- (UIImage *)roundedImageWithRadius:(CGFloat)radius;
- (UIImage *)maskedImageColor:(UIColor *)color;

@end
