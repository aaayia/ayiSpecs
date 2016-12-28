//
//  PhotoPickerCell.h
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/11.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PhotoPickerCell : UICollectionViewCell
@property(strong,nonatomic) UIImageView *photo;
@property(strong,nonatomic) UIButton *selectBtn;

-(void)loadPhotoData:(PHAsset *)assetItem;
- (UIImage *)getImage;


@end
