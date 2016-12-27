//
//  CaptureSessionPipelineViewController.m
//  VIVAT
//
//  Created by 章正义 on 16/3/4.
//  Copyright © 2016年 AnBang. All rights reserved.
//

#import "CaptureSessionPipelineViewController.h"
#import "CaptureSessionCoordinator.h"
#import "PermissionsManager.h"
#import "CameraView.h"
#import "Masonry.h"
#import "UIImage+Extension.h"
#import "PreviewPhotoViewController.h"


@interface CaptureSessionPipelineViewController ()<CaptureSessionCoordinatorDelegate,CameraViewDelegate>

@property (strong, nonatomic) NSMutableArray *photoArray;
@property (nonatomic, strong) CaptureSessionCoordinator *captureSessionCoordinator;
@property(nonatomic,strong)CameraView *focuseView;
@property(nonatomic,strong)UIToolbar *bottomToolbar;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;



@end

@implementation CaptureSessionPipelineViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self creatBGView];
    
    self.takePhotoOfMax = 1;
    self.photoArray = [NSMutableArray arrayWithCapacity:self.takePhotoOfMax];

    self.view.backgroundColor = [UIColor blackColor];
    [self prefersStatusBarHidden];
    [self setUpCaptureSession];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)createBottomBar{
    
    UIView *bottomToolBar = ({
        UIView *view =[[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self.focuseView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.focuseView);
            make.height.equalTo(@(88));
        }];
        view;
    });
    
    
    
    UIButton *completeBtn =({
        UIButton * btn =  [self buttonWithTitle:@"完成" imageName:nil action:@selector(completeItem:)];
        [bottomToolBar addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomToolBar);
            make.left.equalTo(bottomToolBar.mas_left).offset(10);
            make.width.height.equalTo(@(50));
        }];
        btn;
    });
    
    
    UIButton *takeBtn =({
        UIButton *btn = [self buttonWithTitle:nil imageName:@"my-profile-new-photo" action:@selector(takeItem:)];
        [bottomToolBar addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomToolBar);
            make.centerX.equalTo(bottomToolBar.mas_centerX);
            make.width.height.equalTo(@(60));
        }];

        btn;
    });
    
    /*
    UIButton *cancelBtn =({
        UIButton *btn = [self buttonWithTitle:@"取消" imageName:nil action:@selector(cancelItem:)];
        [bottomToolBar addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomToolBar);
            make.right.equalTo(bottomToolBar.mas_right).offset(-10);
            make.width.height.equalTo(@(50));
        }];
        btn;
    });
     */
}

- ( UIButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:35/255.0 green:168/255.0 blue:107/255.0 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)completeItem:(UIButton *)item{
    NSLog(@"%s",__FUNCTION__);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)takeItem:(UIButton *)item{
    NSLog(@"%s",__FUNCTION__);
//    if (_photoArray.count == self.takePhotoOfMax) {
//        [self showAlertView:self.takePhotoOfMax];
//        return;
//    }
    [self.captureSessionCoordinator captureImage];
    UIView *lightScreenView = [[UIView alloc] init];
    lightScreenView.frame = self.view.bounds;
    lightScreenView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lightScreenView];
    [UIView animateWithDuration:.5 animations:^{
        lightScreenView.alpha = 0;
    } completion:^(BOOL finished) {
        [lightScreenView removeFromSuperview];
    }];

}
- (void)cancelItem:(UIButton *)item{
    NSLog(@"%s",__FUNCTION__);
//    PreviewPhotoViewController *previewVC = [[PreviewPhotoViewController alloc]init];
//    [self.navigationController pushViewController:previewVC animated:YES];

//    [self dismissViewControllerAnimated:YES completion:nil];

}


- (void)setUpCaptureSession{
    [self checkPermissions];
  self.captureSessionCoordinator = [CaptureSessionCoordinator new];

    [_captureSessionCoordinator setDelegate:self callbackQueue:dispatch_get_main_queue()];
    [self configureInterface];


}
- (void)checkPermissions
{
    PermissionsManager *pm = [PermissionsManager new];
    [pm checkCameraAuthorizationStatusWithBlock:^(BOOL granted) {
        if (!granted) {
            NSLog(@"we don't have permission to use the camera");

        }

    } vc:self];
}

- (void)configureInterface
{
    AVCaptureVideoPreviewLayer *previewLayer = [_captureSessionCoordinator previewLayer];
    self.previewLayer = previewLayer;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.bounds;
    
    [self.view.layer insertSublayer:previewLayer atIndex:0];

    
    [_captureSessionCoordinator startRunning];
    CameraView *focuseView = [[CameraView alloc]initWithFrame:self.view.frame];
    self.focuseView = focuseView;
    focuseView.delegate = self;
    [self.view addSubview:focuseView];
    [self createBottomBar];


}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)showAlertView:(NSInteger)photoNumOfMax
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:@"最多连拍张数为%ld张图片",(long)photoNumOfMax]preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

+ (void)show:(UIViewController *)vc takePhotoOfMax:(NSInteger)takePhotoOfMax{
    CaptureSessionPipelineViewController *pipelineVC = [[CaptureSessionPipelineViewController alloc]init];
    pipelineVC.takePhotoOfMax = takePhotoOfMax;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:pipelineVC];
    __weak typeof(vc) weakVC =vc;
    if (weakVC) {
        [vc presentViewController:nav animated:YES completion:nil];
 
    }
}

#pragma mark -- CameraViewDelegate
-(void)cameraDidSelected:(CameraView *)camera{
    [self.captureSessionCoordinator captureFocusModeAutoFocus];
}



#pragma mark -- CaptureSessionCoordinatorDelegate

- (void)coordinator:(CaptureSessionCoordinator *)coordinator didFinishCaptureImage:(UIImage *)captureImage{
    
    if (!captureImage) return;
    
  UIImage *or_image = [UIImage fixOrientation:captureImage];
    
    __weak typeof(self) weakSelf = self;
    PreviewPhotoViewController *previewVC = [[PreviewPhotoViewController alloc]initWithCallBack:^(id image) {
        [weakSelf.photoArray addObject:image];
        
    [[NSNotificationCenter defaultCenter]postNotificationName:TakingPicturesFinishNotification object:self userInfo:@{@"image":weakSelf.photoArray}];
    }];
    previewVC.previewImage = or_image;
    [self.navigationController pushViewController:previewVC animated:YES];
}

@end
