//
//  PlaceholderCell.m
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/14.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "PlaceholderCell.h"

@implementation PlaceholderCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    CGFloat photoSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
    
    _photo = ({
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, photoSize, photoSize)];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"my-profile-select-photo_default"];
        [self.contentView addSubview:imageView];
        imageView;
    });
    
}


@end
