//
//  CaptureSessionCoordinator.m
//  VIVAT
//
//  Created by 章正义 on 16/3/4.
//  Copyright © 2016年 AnBang. All rights reserved.
//

#import "CaptureSessionCoordinator.h"
#import <ImageIO/ImageIO.h>

@interface CaptureSessionCoordinator ()
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation CaptureSessionCoordinator
- (instancetype)init
{
    self = [super init];
    if(self){
        _sessionQueue = dispatch_queue_create( "com.example.capturepipeline.session", DISPATCH_QUEUE_SERIAL );
        _captureSession = [self setupCaptureSession];
    }
    return self;
}

- (AVCaptureSession *)setupCaptureSession{
    AVCaptureSession *captureSession = [[AVCaptureSession alloc]init];
    
    if(![self addDefaultCameraInputToCaptureSession:captureSession]){
        NSLog(@"failed to add camera input to capture session");
    }
    
    return captureSession;

}
- (BOOL)addDefaultCameraInputToCaptureSession:(AVCaptureSession *)captureSession
{
    NSError *error;
    self.cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *cameraDeviceInput =[[AVCaptureDeviceInput alloc] initWithDevice:self.cameraDevice error:&error];
    if(error){
        NSLog(@"error configuring camera input: %@", [error localizedDescription]);
        return NO;
    } else {
        self.captureDeviceInput = cameraDeviceInput;
        self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
        // 设置指定接收静态图像选项
        [self.captureOutput setOutputSettings:outputSettings];

        [captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        
       BOOL succ = [self addOutput:_captureOutput toCaptureSession:captureSession];
        BOOL success = [self addInput:cameraDeviceInput toCaptureSession:captureSession];

        
        return success||succ;
    }
    

    
}

- (BOOL)addInput:(AVCaptureDeviceInput *)input toCaptureSession:(AVCaptureSession *)captureSession
{
    if([captureSession canAddInput:input]){
        [captureSession addInput:input];
        return YES;
    } else {
        NSLog(@"can't add input: %@", [input description]);
    }
    return NO;
}


- (BOOL)addOutput:(AVCaptureOutput *)output toCaptureSession:(AVCaptureSession *)captureSession
{
    if([captureSession canAddOutput:output]){
        [captureSession addOutput:output];
        return YES;
    } else {
        NSLog(@"can't add output: %@", [output description]);
    }
    return NO;
}

- (void)setDelegate:(id<CaptureSessionCoordinatorDelegate>)delegate callbackQueue:(dispatch_queue_t)delegateCallbackQueue
{
    if(delegate && ( delegateCallbackQueue == NULL)){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Caller must provide a delegateCallbackQueue" userInfo:nil];
    }
    @synchronized(self)
    {
        _delegate = delegate;
        if (delegateCallbackQueue != _delegateCallbackQueue){
            _delegateCallbackQueue = delegateCallbackQueue;
        }
    }
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if(!_previewLayer && _captureSession){
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    }
    return _previewLayer;
}


- (void)captureImage{
    //获取连接
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    __weak CaptureSessionCoordinator *weakSelf = self;
    //获取图片
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         CFDictionaryRef exifAttachments =
         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *t_image = [UIImage imageWithData:imageData];
         
         if ([weakSelf.delegate respondsToSelector:@selector(coordinator:didFinishCaptureImage:)]) {
             if (weakSelf.delegateCallbackQueue) {
                 dispatch_async(weakSelf.delegateCallbackQueue, ^{
                     [weakSelf.delegate coordinator:weakSelf didFinishCaptureImage:t_image];
                 });
             }
         }
         
     }];

}
/** 改变前后摄像头 */
- (void)changeCameraDevice
{
    
    NSArray *inputs = self.captureSession.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            [self.captureSession beginConfiguration];
            
            [self.captureSession removeInput:input];
            [self.captureSession addInput:newInput];
            
            // 最外层的调用commitConfiguration更改生效一次。
            [self.captureSession commitConfiguration];
            break;
        }
    }
}

/**  获取前后捕捉设备 */
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

/** 打开关闭闪光灯*/
- (void) flashLightModel : (codeBlock) codeBlock{
    if (!codeBlock) return;
    //会话层开始配置
    [self.captureSession beginConfiguration];
    //请求独占访问硬件设备配置属性
    [self.cameraDevice lockForConfiguration:nil];
    codeBlock();
    [self.cameraDevice unlockForConfiguration];
    [self.captureSession commitConfiguration];
    [self.captureSession startRunning];
}

/** 聚焦 */
- (void)captureFocusModeAutoFocus{
    //聚焦
    [self.cameraDevice lockForConfiguration:nil];
    [self.cameraDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    [self.cameraDevice setFocusPointOfInterest:CGPointMake(50,50)];
    //操作完成后，记得进行unlock。
    [self.cameraDevice unlockForConfiguration];
}


- (void)startRecording
{
    //overwritten by subclass
}

- (void)stopRecording
{
    //overwritten by subclass
}

- (void)startRunning
{
    dispatch_sync( _sessionQueue, ^{
        [_captureSession startRunning];
    } );
}

- (void)stopRunning
{
    dispatch_sync( _sessionQueue, ^{
        [self stopRecording];
        [_captureSession stopRunning];
    } );
}

- (void)dealloc{
    if (self.captureSession) {
        [self.captureSession stopRunning];
        [self.captureSession removeInput:self.captureDeviceInput];
        self.captureDeviceInput = nil;
        [self.captureSession removeOutput:self.captureOutput];
        self.captureOutput = nil;
        self.captureSession = nil;
    }
    self.cameraDevice = nil;
    NSLog(@"captureSession----dealloc");

}

@end
