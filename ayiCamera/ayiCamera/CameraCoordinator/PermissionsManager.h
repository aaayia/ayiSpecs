//
//  PermissionsManager.h
//  VIVAT
//
//  Created by 章正义 on 16/3/4.
//  Copyright © 2016年 AnBang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface PermissionsManager : NSObject
- (void)checkPhotoLibraryAuthorizationStatusWithBlock:(void(^)(BOOL granted))block;
- (void)checkCameraAuthorizationStatusWithBlock:(void(^)(BOOL granted))block vc:(UIViewController *)vc;
@end
