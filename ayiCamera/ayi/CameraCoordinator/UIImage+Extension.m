//
//  UIImage+Extension.m
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/8.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (UIImage *)fixOrientation:(UIImage *)srcImg{
    
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    
    UIImage * noImage= srcImg;
   UIDevice *currentDevice = [UIDevice currentDevice];
    switch (currentDevice.orientation) {
            
        case UIDeviceOrientationPortrait:{
            CGImageRef cgRef = srcImg.CGImage;
            noImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationRight];
        }
            break;
            
        case UIDeviceOrientationLandscapeLeft:{
            CGImageRef cgRef = srcImg.CGImage;
            noImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationUp];
            
        }
            
            break;
        case UIDeviceOrientationLandscapeRight:{
            CGImageRef cgRef = srcImg.CGImage;
            noImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationDown];
            
        }
            
            break;
            
        default:
            break;
    }
    return noImage;
    
}

+(UIImage *)configurationImage:(UIImage *)image{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyyMMddHHmmss";
    NSString *currentTimeStr = [[formater stringFromDate:[NSDate date]] stringByAppendingFormat:@"_%d" ,arc4random_uniform(10000)];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:currentTimeStr];
    
    NSData * imageData= UIImageJPEGRepresentation(image, 0.8);
    NSLog(@"imageData---%f",imageData.length / 1024.0);
//    BOOL bl= [imageData writeToFile:path atomically:YES];
//    if (!bl)  {
//        NSLog(@"---save Image Error");
//        return nil;
//    }

    
    
    return [UIImage imageWithData:imageData];
}

@end
