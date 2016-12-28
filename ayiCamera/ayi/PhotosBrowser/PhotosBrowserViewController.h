//
//  PhotosBrowserViewController.h
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/8.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSArray<UIImage *> *(^callBack)();


@interface PhotosBrowserViewController : UIViewController
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray<UIImage *> *photoDataArray;
- (void)show;





@end
