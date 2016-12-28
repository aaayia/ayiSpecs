//
//  PhotoPickerViewController.m
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/11.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "PhotoPickerCell.h"
#import "PhotoCoordinator.h"
#import "Masonry.h"
#import "PlaceholderCell.h"
#import "PhotoAlbumViewController.h"
#import "CaptureSessionPipelineViewController.h"
#import "PermissionsManager.h"


@interface PhotoPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) NSMutableArray *selectArray;
@property (strong, nonatomic) UICollectionView *picsCollection;
@property (strong, nonatomic) UIButton *selectBtn;
@property (assign, nonatomic) BOOL isSelect;
@property (strong, nonatomic) UIBarButtonItem *backBtn;
@property (strong, nonatomic) UIBarButtonItem *cancelBtn;
@property (strong, nonatomic) UIButton *doneBtn;                       //完成按钮
@property (strong, nonatomic) UIButton *previewBtn;                    //预览按钮
@property (strong, nonatomic) UILabel *totalNumLabel;
@property (strong, nonatomic) UILabel *numSelectLabel;

@property(nonatomic,strong)UIButton * bottomBtn;

@property(nonatomic,strong)PHFetchResult * fetchResul;
@property(nonatomic,copy)CallBack callBack;



@end



@implementation PhotoPickerViewController

static NSString * const reuseIdentifier = @"PhotoPickerCell";
static NSString * const reuseId = @"PlaceholderCell";

-(NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

-(NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

-(UILabel *)totalNumLabel{
    if (!_totalNumLabel) {
        _totalNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.frame), 20)];
        _totalNumLabel.textColor = [UIColor blackColor];
        _totalNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalNumLabel;
}


- (instancetype)initWithCallBack:(CallBack)block{
    self = [super init];
    if (self) {
        self.callBack = block;
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupCollectionViewUI];
    [self loadPhotoData];
    [self setUpBottomButtom];
    [self setRightBtn];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(takingPicturesFinish:) name:TakingPicturesFinishNotification object:nil];
}

- (void)takingPicturesFinish:(NSNotification *)not{
    if (!not.userInfo[@"image"]) return;
    
    NSArray *imageArr = not.userInfo[@"image"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.callBack) {
            self.callBack(imageArr);
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
    
}

-(void)loadPhotoData
{
    
    [[PermissionsManager new]checkPhotoLibraryAuthorizationStatusWithBlock:^(BOOL granted) {
        if (granted) {
            PHFetchResult * cameraRollFetchResul = [[PhotoCoordinator shareCoordinator]getCameraRollFetchResul];
            self.fetchResul = cameraRollFetchResul;
        }
    }];

}

- (void)setFetchResul:(PHFetchResult *)fetchResul{
    _fetchResul = fetchResul;
   NSMutableArray *assets = [[PhotoCoordinator shareCoordinator]getPhotoAssetsWithFetchResult:fetchResul];
    [self setUpCollectionDataArray:assets];
    [self.picsCollection reloadData];
    [self refreshTotalNumLabelData:self.photoArray.count];
}

- (void)setUpCollectionDataArray:(NSArray *)arr{
  PHAsset * asset = [[PHAsset alloc]init];
    self.photoArray = [NSMutableArray arrayWithObject:asset];
    for (PHAsset *asset in arr) {
        [self.photoArray addObject:asset];
    }
}

-(void)refreshTotalNumLabelData:(NSInteger)totalNum
{
    self.totalNumLabel.text = [NSString stringWithFormat:@"%ld 张照片",(long)totalNum-1];
}
- (void)setRightBtn{
    
    UIBarButtonItem *moreItem = ({
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(moreItemClick)];
        item.tintColor =[UIColor colorWithRed:35/255.0 green:168/255.0 blue:107/255.0 alpha:1];
        self.navigationItem.rightBarButtonItem = item;
        item;
    });
}

- (void)moreItemClick{
    
    __weak typeof(self) weakSelf = self;
    [PhotoAlbumViewController showAlbumViewController:self callBack:^(id asset) {
        [weakSelf.selectArray removeAllObjects];
       weakSelf.fetchResul = [[PhotoCoordinator shareCoordinator]getFetchResultWithAssetCollection:asset];
    }];
    
    NSLog(@"%s",__FUNCTION__);
}


- (void)setUpBottomButtom{
    _bottomBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:35/255.0 green:168/255.0 blue:107/255.0 alpha:1];
        [btn addTarget:self action:@selector(tureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(@(44));
        }];
        btn;
    });
}

- (void)tureBtnClick{
    NSLog(@"%@",self.selectArray);
    
    if (self.selectArray.count == 0) {
        [self showAlertControllerWithTitle:@"提示" message:@"请选择照片"];
        return;
    }else{
        NSMutableArray *images = [NSMutableArray array];
        for (NSIndexPath *path in self.selectArray) {
            
            [[PhotoCoordinator shareCoordinator]getImageObject:[self.photoArray objectAtIndex:path.row] complection:^(UIImage *image, BOOL isDegraded) {
                if (isDegraded) {
                    return;
                }
                if (image){
                    [images addObject:image];
                }
                if (images.count < self.selectArray.count){
                  return;  
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.callBack) {
                        self.callBack(images);
                    }
                });


            }];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}

-(void)setupCollectionViewUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    CGFloat photoSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
    flowLayout.minimumInteritemSpacing = 1.0;
    flowLayout.minimumLineSpacing = 1.0;
    flowLayout.itemSize = (CGSize){photoSize,photoSize};
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _picsCollection = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    //设置Cell多选
    _picsCollection.allowsMultipleSelection = YES;
    [_picsCollection registerClass:[PhotoPickerCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [_picsCollection registerClass:[PlaceholderCell class] forCellWithReuseIdentifier:reuseId];

    [_picsCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    flowLayout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 70);
    _picsCollection.delegate = self;
    _picsCollection.dataSource = self;
    _picsCollection.backgroundColor = [UIColor whiteColor];
    [_picsCollection setUserInteractionEnabled:YES];
    _picsCollection.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_picsCollection];
    [_picsCollection reloadData];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView: (UICollectionView *)collectionView
     numberOfItemsInSection: (NSInteger)section {
    
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView: (UICollectionView *)collectionView
                  cellForItemAtIndexPath: (NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        PlaceholderCell *placeholderCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
        return placeholderCell;
    }else{
        //通过Cell重用标示符来获取Cell
        PhotoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: reuseIdentifier
                                                                          forIndexPath: indexPath];
        
        [cell loadPhotoData:self.photoArray[indexPath.row]];
        [self changeSelectStateWithCell:cell];
        return cell;
    }
}

/**
 * 设置Setion的Header和Footer(Supplementary View)
 */
- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView
           viewForSupplementaryElementOfKind: (NSString *)kind
                                 atIndexPath: (NSIndexPath *)indexPath{
    
    UICollectionReusableView *footerView = [[UICollectionReusableView alloc]init];
    footerView.backgroundColor = [UIColor redColor];
    if (kind == UICollectionElementKindSectionFooter){
        footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    }
    
    [footerView addSubview:self.totalNumLabel];
    return footerView;
    
}

- (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *canceAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:canceAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark <UICollectionViewDelegate>


/**
 * Cell是否可以选中
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


/**
 * Cell多选时是否支持取消功能
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

/**
 * Cell选中调用该方法
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row != 0) {
        if (self.selectArray.count < self.photosCountOfMax ) {
            PhotoPickerCell *currentSelecteCell = (PhotoPickerCell *)[self.picsCollection cellForItemAtIndexPath:indexPath];
            [self changeSelectStateWithCell:currentSelecteCell];
            if (![self.selectArray containsObject:indexPath]) {
                [self.selectArray addObject:indexPath];
            }
        }else{
            
          NSString *msg =   [NSString stringWithFormat:@"最多选择%lu张照片",(unsigned long)self.photosCountOfMax];
            [self showAlertControllerWithTitle:@"提示" message:msg];
            [self.picsCollection deselectItemAtIndexPath:indexPath animated:YES];
        }
  
    }else {
        [CaptureSessionPipelineViewController show:self takePhotoOfMax:6];
    }

}

/**
 * Cell取消选中调用该方法
 */
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        //获取当前变化的Cell
        PhotoPickerCell *currentSelecteCell = (PhotoPickerCell *)[self.picsCollection cellForItemAtIndexPath:indexPath];
        [self changeSelectStateWithCell:currentSelecteCell];
        if ([self.selectArray containsObject:indexPath]) {
            [self.selectArray removeObject:indexPath];
        }
    }else {
        [CaptureSessionPipelineViewController show:self takePhotoOfMax:self.photosCountOfMax];
    }
}


/**
 * Cell根据Cell选中状态来改变Cell上Button按钮的状态
 */
- (void) changeSelectStateWithCell: (PhotoPickerCell *) currentSelecteCell{
    
    
    currentSelecteCell.selectBtn.selected = currentSelecteCell.selected;
    currentSelecteCell.photo.alpha = currentSelecteCell.selected ?0.7:1;

    if (currentSelecteCell.selected == YES){
        //NSLog(@"第%ld个Section上第%ld个Cell被选中了",indexPath.section ,indexPath.row);
        return;
    }
    
    if (currentSelecteCell.selected == NO){
        //NSLog(@"第%ld个Section上第%ld个Cell取消选中",indexPath.section ,indexPath.row);
    }
    
}

/**
 * Cell将要出现的时候调用该方法
 */
- (void)collectionView: (UICollectionView *)collectionView
       willDisplayCell: (UICollectionViewCell *)cell
    forItemAtIndexPath: (NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
}

/**
 * Cell出现后调用该方法
 */
- (void)collectionView: (UICollectionView *)collectionView
  didEndDisplayingCell: (UICollectionViewCell *)cell
    forItemAtIndexPath: (NSIndexPath *)indexPath{
}


- (void)dealloc{
    NSLog(@"PhotoPickerViewController---dealloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
