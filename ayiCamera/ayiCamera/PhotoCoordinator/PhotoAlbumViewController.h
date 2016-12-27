//
//  PhotoAlbumViewController.h
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/11.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^seletctBack)(id asset);

@interface PhotoAlbumViewController : UIViewController

+ (void)showAlbumViewController:(UIViewController *)vc callBack:(seletctBack)callBack;

@end
