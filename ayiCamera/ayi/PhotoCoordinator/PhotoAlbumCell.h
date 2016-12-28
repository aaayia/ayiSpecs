//
//  PhotoAlbumCell.h
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/11.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PhotoAlbumCell : UITableViewCell
/* 相册图片，显示相册的最后一张图片 */
@property(strong,nonatomic) UIImageView *coverImage;
/* 相册标题，显示相册的标题*/
@property(strong,nonatomic) UILabel *title;
/* 相册副标题，显示相册中含有多少张图片*/
@property(strong,nonatomic) UILabel *subTitle;
/* 加载数据方法*/
-(void)loadPhotoAlbumData:(PHAssetCollection *)collectionItem;

@end
