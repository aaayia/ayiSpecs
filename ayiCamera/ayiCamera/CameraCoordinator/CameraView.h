//
//  JHCameraView.h
//  CustomCamera
//
//  Created by 章正义 on 15/10/20.
//  Copyright (c) 2015年 ayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraView;

@protocol CameraViewDelegate <NSObject>

@optional

//点击聚焦调用
- (void) cameraDidSelected : (CameraView *) camera;

@end

@interface CameraView : UIView

/**  代理 */
@property (weak, nonatomic) id <CameraViewDelegate> delegate;

@end
