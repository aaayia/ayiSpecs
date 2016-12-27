//
//  PhotoCoordinator.m
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/11.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "PhotoCoordinator.h"

@implementation PhotoCoordinator
+ (instancetype)shareCoordinator{
    static PhotoCoordinator *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}


/* 获取全部相册*/
- (NSMutableArray<PHAssetCollection *> *)getAllAlbums{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    
    /** 获取系统相册 */
    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:fetchOptions];
    
    [dataArray addObject:[smartAlbumsFetchResult objectAtIndex:0]];
    
    /** 获取用户自定义相册 */
    PHFetchResult *smartAlbumsFetchResult1 = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:fetchOptions];
    
    for (PHAssetCollection *sub in smartAlbumsFetchResult1)
    {
        [dataArray addObject:sub];
        
    }
    
    return dataArray;

}
/* 只获取相机胶卷结果集*/
- (PHFetchResult *)getCameraRollFetchResul{
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    
    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:fetchOptions];
    
    
    PHFetchResult *fetch = [PHAsset fetchAssetsInAssetCollection:[smartAlbumsFetchResult objectAtIndex:0] options:nil];
    return fetch;

}
/* 获取某一个相册的结果集*/
-(PHFetchResult *) getFetchResultWithAssetCollection:(PHAssetCollection *)asset{
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:asset options:nil];
    return fetchResult;

}
/* 获取图片实体，并把图片结果存放到数组中，返回值数组*/
-(NSMutableArray<PHAsset *> *) getPhotoAssetsWithFetchResult:(PHFetchResult *)fetchResult{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (PHAsset *asset in fetchResult) {
        //只添加图片类型资源，去除视频类型资源
        //当mediaType == 2时，这个资源则为视频资源
        if (asset.mediaType == 1) {
            [dataArray addObject:asset];
        }
        
    }
    return dataArray;

}
/* 回调方法使用数组*/
-(void) getImageObject:(id)asset complection:(void (^)(UIImage *image, BOOL isDegraded))complection{
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat multiple = [UIScreen mainScreen].scale;
        CGFloat pixelWidth = photoWidth * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined) {
                if (complection) complection(result,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
        }];
        
    }

}


@end
