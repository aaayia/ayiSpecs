//
//  ViewController.m
//  ayiCamera
//
//  Created by ayi on 2016/12/27.
//  Copyright © 2016年 ayi. All rights reserved.
//

#import "ViewController.h"
#import "PreviewPhotoViewController.h"
#import "PhotoPickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    PreviewPhotoViewController *vc = [[PreviewPhotoViewController alloc]initWithCallBack:^(id image) {
//        
//    }];
    
    __weak typeof(self) weakSelf = self;
    PhotoPickerViewController *vc = [[PhotoPickerViewController alloc]initWithCallBack:^(NSArray<UIImage *> *images) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    vc.photosCountOfMax = 3;
    [self presentViewController:vc animated:YES completion:nil];
}


@end
