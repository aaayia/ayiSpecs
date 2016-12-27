
//
//  PermissionsManager.m
//  VIVAT
//
//  Created by 章正义 on 16/3/4.
//  Copyright © 2016年 AnBang. All rights reserved.
//

#import "PermissionsManager.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#import <Photos/Photos.h>

@interface PermissionsManager()<UIAlertViewDelegate>

@end

@implementation PermissionsManager

- (void)checkCameraAuthorizationStatusWithBlock:(void(^)(BOOL granted))block vc:(UIViewController *)vc
{
    NSString *mediaType = AVMediaTypeVideo;
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (!granted){
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Camera disabled" message:@"This app doesn't have permission to use the camera, please go to the Settings app > Privacy > Camera and enable access." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cance = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *setting = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                
                
                [alert addAction:cance];
                [alert addAction:setting];
                [vc presentViewController:alert animated:YES completion:nil];

            });
        }
        if(block)
            block(granted);
    }];
}


- (void)checkPhotoLibraryAuthorizationStatusWithBlock:(void(^)(BOOL granted))block{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Photos disabled" message:@"This app doesn't have permission to use the photo, please go to the Settings app > Privacy > photo and enable access." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cance = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *setting = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];

            
            [alert addAction:cance];
            [alert addAction:setting];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];

            block(NO);
        });
        
    }else if(status == PHAuthorizationStatusNotDetermined){
        /* * * 第一次安装应用时直接进行这个判断进行授权 * * */
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            //授权后直接打开照片库
            if (status == PHAuthorizationStatusAuthorized){
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES);
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(NO);
                });
            }
        }];
    }else if (status == PHAuthorizationStatusAuthorized){
        block(YES);
    }
}

#pragma mark - UIAlertViewDelegate methods




@end
