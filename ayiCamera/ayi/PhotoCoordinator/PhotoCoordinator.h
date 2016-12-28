//
//  PhotoCoordinator.h
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/11.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotoCoordinator : NSObject
+ (instancetype)shareCoordinator;
/* 获取全部相册*/
- (NSMutableArray<PHAssetCollection *> *)getAllAlbums;
/* 只获取相机胶卷结果集*/
- (PHFetchResult *)getCameraRollFetchResul;
/* 获取某一个相册的结果集*/
-(PHFetchResult *) getFetchResultWithAssetCollection:(PHAssetCollection *)asset;
/* 获取图片实体，并把图片结果存放到数组中，返回值数组*/
-(NSMutableArray<PHAsset *> *) getPhotoAssetsWithFetchResult:(PHFetchResult *)fetchResult;
/* 回调方法使用数组*/
-(void) getImageObject:(id)asset complection:(void (^)(UIImage *image, BOOL isDegraded))complection;




@end
