//
//  CaptureSessionPipelineViewController.h
//  VIVAT
//
//  Created by 章正义 on 16/3/4.
//  Copyright © 2016年 AnBang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLOR_HEX(rgbValue) COLOR_RGB((((rgbValue) & 0xFF0000) >> 16), (((rgbValue) & 0xFF00) >> 8), (((rgbValue) & 0xFF)))

static NSString *const TakingPicturesFinishNotification = @"TakingPicturesFinishNotification";

@interface CaptureSessionPipelineViewController : UIViewController
@property (assign, nonatomic) NSInteger takePhotoOfMax;

+ (void)show:(UIViewController *)vc takePhotoOfMax:(NSInteger)takePhotoOfMax;
@end
