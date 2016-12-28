//
//  CaptureSessionCoordinator.h
//  VIVAT
//
//  Created by 章正义 on 16/3/4.
//  Copyright © 2016年 AnBang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef void(^codeBlock)();

@protocol CaptureSessionCoordinatorDelegate;


@interface CaptureSessionCoordinator : NSObject
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *cameraDevice;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;
@property (strong, nonatomic) AVCaptureDeviceInput * captureDeviceInput;

@property (strong, nonatomic) AVCaptureMetadataOutput * captureMetadataOutput;

@property (nonatomic, strong) dispatch_queue_t delegateCallbackQueue;
@property (nonatomic, weak) id<CaptureSessionCoordinatorDelegate> delegate;

- (void)setDelegate:(id<CaptureSessionCoordinatorDelegate>)delegate callbackQueue:(dispatch_queue_t)delegateCallbackQueue;

- (BOOL)addInput:(AVCaptureDeviceInput *)input toCaptureSession:(AVCaptureSession *)captureSession;
- (BOOL)addOutput:(AVCaptureOutput *)output toCaptureSession:(AVCaptureSession *)captureSession;

- (void)captureImage;
- (void)changeCameraDevice;
- (void)flashLightModel:(codeBlock) codeBlock;
- (void)captureFocusModeAutoFocus;

- (void)startRunning;
- (void)stopRunning;

/*
- (void)startRecording;
- (void)stopRecording;
 */

- (AVCaptureVideoPreviewLayer *)previewLayer;

@end

@protocol CaptureSessionCoordinatorDelegate <NSObject>

@required

- (void)coordinator:(CaptureSessionCoordinator *)coordinator didFinishCaptureImage:(UIImage *)captureImage;

@end
