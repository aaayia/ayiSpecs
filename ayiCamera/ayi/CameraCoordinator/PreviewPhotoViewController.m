//
//  PreviewPhotoViewController.m
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/8.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "PreviewPhotoViewController.h"
#import "Masonry.h"
#import "UIImage+Extension.h"

@interface PreviewPhotoViewController ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,copy)callBack callBack;


@end

@implementation PreviewPhotoViewController

- (instancetype)initWithCallBack:(callBack)callBack{
    self = [super init];
    if (self) {
        self.callBack = callBack;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];

    [self initImageView];
    [self createBottomBar];
}

- (void)initImageView{
    self.imageView = [[UIImageView alloc]init];
    self.imageView.frame = self.view.bounds;
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.previewImage;
    [self.view addSubview:self.imageView];
}

- (void)createBottomBar{
    
    UIView *bottomToolBar = ({
        UIView *view =[[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:35/255.0 green:168/255.0 blue:107/255.0 alpha:1];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.equalTo(@(64));
        }];
        view;
    });
    
    
    
    UIButton *completeBtn =({
        UIButton * btn =  [self buttonWithTitle:@"完成" imageName:nil action:@selector(completeItem:)];
        [bottomToolBar addSubview:btn];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomToolBar);
            make.left.equalTo(bottomToolBar.mas_left).offset(10);
            make.width.height.equalTo(@(50));
        }];
        btn;
    });
    
    
    UIButton *cancelBtn =({
        UIButton *btn = [self buttonWithTitle:@"取消" imageName:nil action:@selector(cancelItem:)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bottomToolBar addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomToolBar);
            make.right.equalTo(bottomToolBar.mas_right).offset(-10);
            make.width.height.equalTo(@(50));
        }];
        btn;
    });
}

- ( UIButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)completeItem:(UIButton *)item{
    NSLog(@"%s",__FUNCTION__);
  UIImage *image = [UIImage configurationImage:self.previewImage];
    if (self.callBack) {
        self.callBack(image);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelItem:(UIButton *)item{
    NSLog(@"%s",__FUNCTION__);
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
