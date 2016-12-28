//
//  PhotoPickerCell.m
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/11.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "PhotoPickerCell.h"

@interface PhotoPickerCell ()

@end

@implementation PhotoPickerCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setUpUI{
    CGFloat photoSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
    
    _photo = ({
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, photoSize, photoSize)];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageView];
        imageView;
    });
    
    _selectBtn = ({
        CGFloat picViewSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
        CGFloat btnSize = picViewSize / 4;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(picViewSize - btnSize - 5, picViewSize - btnSize -5, btnSize, btnSize)];
        [btn setImage:[UIImage imageNamed:@"step4-upload-pictures-select"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"select_no.png"] forState:UIControlStateNormal];
//        [NSNotificationCenter defaultCenter]
        [self.contentView addSubview:btn];
        btn;
 
    });

}

-(void)loadPhotoData:(PHAsset *)assetItem
{
    if ([assetItem isKindOfClass:[PHAsset class]]) {
        
        
        PHAsset *phAsset = assetItem;
        
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info){
            NSData *imageData = UIImageJPEGRepresentation(result, 0.1);
            self.photo.image = [UIImage imageWithData:imageData];;
        }];
        
    }
}

- (UIImage *)getImage{
    return  self.photo.image;
}


@end
