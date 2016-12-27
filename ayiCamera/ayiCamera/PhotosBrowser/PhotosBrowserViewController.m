//
//  PhotosBrowserViewController.m
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/8.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "PhotosBrowserViewController.h"
#import "SwipeView.h"

@interface PhotosBrowserViewController ()<SwipeViewDataSource,SwipeViewDelegate>
@property (nonatomic, strong) UICollectionView *picBrowse;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;


@property (nonatomic, weak)  SwipeView *swipeView;


@end

@implementation PhotosBrowserViewController

static NSString * cellID = @"PhotosBrowserCell";

-(NSMutableArray *)photoDataArray{
    if (!_photoDataArray) {
        _photoDataArray = [NSMutableArray array];
    }
    return _photoDataArray;
}

- (void)viewDidLoad {
        [super viewDidLoad];
//    self.navigationController.navigationBar.hidden  = YES;
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    self.navigationController.navigationBar.opaque = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
        [self ceartUI];
}

- (void)ceartUI{
    SwipeView *swipeView = [[SwipeView alloc]init];
    self.swipeView = swipeView;
    swipeView.frame = self.view.bounds;
    swipeView.frame = CGRectOffset(self.view.bounds, 0, -44);
    swipeView.delegate = self;
    swipeView.dataSource = self;
    [self.view addSubview:swipeView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ( self.navigationController.navigationBarHidden == YES )
    {
        [self.view setBounds:CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    else
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.swipeView scrollToPage:_currentPage duration:0];

}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return [_photoDataArray count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = nil;
    
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
//        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.center = self.swipeView.center;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
//        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = 1;
        [view addSubview:imageView];
        
        
    }
    else
    {
        imageView = (UIImageView *)[view viewWithTag:1];
    }
    
    imageView.image = [self.photoDataArray objectAtIndex:index];
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}

- (void)setCurrentPage:(NSUInteger)currentPage{
    _currentPage = currentPage;
    [self.swipeView scrollToPage:currentPage duration:0];
}


@end
