//
//  UIImage+Extension.h
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/8.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *)fixOrientation:(UIImage *)srcImg;

+(UIImage *)configurationImage:(UIImage *)image;

@end
