//
//  PhotoAlbumCell.m
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/11.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "PhotoAlbumCell.h"

@interface PhotoAlbumCell()

@end

@implementation PhotoAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _coverImage =({
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageView];
        imageView;
    });
    
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width - 90;
    _title = ({
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, labelWidth, 25)];
        lb.textColor = [UIColor blackColor];
        [self.contentView addSubview:lb];
        lb;
    });
    
    _subTitle = ({
        UILabel *subLb = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, labelWidth, 25)];
        subLb.textColor = [UIColor blackColor];
        [self.contentView addSubview:subLb];
        subLb;
    });
    
 
    
    CGFloat right = [UIScreen mainScreen].bounds.size.width;
    UIImageView *right_Cell = [[UIImageView alloc]initWithFrame:CGRectMake(right - 29, 25, 9, 20)];
//   right_Cell.image = PhotoListRightBtn;
    [self.contentView addSubview:right_Cell];

}

-(void)loadPhotoAlbumData:(PHAssetCollection *)collectionItem{
    if ([collectionItem isKindOfClass:[PHAssetCollection class]]) {
        PHFetchResult *group = [PHAsset fetchAssetsInAssetCollection:collectionItem options:nil];
        [[PHImageManager defaultManager] requestImageForAsset:group.lastObject
                                                   targetSize:CGSizeMake(200,200)
                                                  contentMode:PHImageContentModeDefault
                                                      options:nil
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    if (result == nil) {
                                                        self.coverImage.image = [UIImage imageNamed:@""];
                                                    }else{
                                                        self.coverImage.image = result;
                                                    }
                                                }];
        PHAssetCollection *titleAsset = collectionItem;
        
        NSLog(@"---%@",titleAsset.localizedTitle);
        if ([titleAsset.localizedTitle isEqualToString:@"Camera Roll"]) {
            self.title.text = @"相机胶卷";
        }else{
            self.title.text = [NSString stringWithFormat:@"%@",titleAsset.localizedTitle];
        }
        self.subTitle.text = [NSString stringWithFormat:@"%lu",(unsigned long)group.count];
    }

}

@end
