//
//  PreviewPhotoViewController.h
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/8.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callBack)(id image);

@interface PreviewPhotoViewController : UIViewController
- (instancetype)initWithCallBack:(callBack)callBack;
@property(nonatomic,strong)UIImage *previewImage;

@end
