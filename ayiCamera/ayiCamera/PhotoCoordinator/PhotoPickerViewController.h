//
//  PhotoPickerViewController.h
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/11.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBack)(NSArray<UIImage *> *images);

@interface PhotoPickerViewController : UIViewController
@property(nonatomic,assign)NSUInteger photosCountOfMax;
- (instancetype)initWithCallBack:(CallBack)block;
@end
