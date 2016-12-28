//
//  PhotoAlbumViewController.m
//  ZZPhotoKit
//
//  Created by 章正义 on 16/3/11.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "PhotoAlbumViewController.h"
#import <Photos/Photos.h>
#import "PhotoCoordinator.h"
#import "PhotoAlbumCell.h"
#import "PermissionsManager.h"

@interface PhotoAlbumViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView *alumbTable;
@property(strong,nonatomic) PHPhotoLibrary *assetsLibrary;
@property(strong,nonatomic) NSMutableArray *alubms;
@property(strong,nonatomic) UIBarButtonItem *closeBtn;
@property(nonatomic,copy)seletctBack callBack;



@end

@implementation PhotoAlbumViewController

- (NSMutableArray *)alubms{
    if (!_alubms) {
        _alubms = [NSMutableArray array];
    }
    return _alubms;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initUI];
    [[PermissionsManager new]checkPhotoLibraryAuthorizationStatusWithBlock:^(BOOL granted) {
        if (granted) {
            self.alubms = [[PhotoCoordinator shareCoordinator]getAllAlbums];
        }
    }];

    
}

- (void)initUI{
    
    _closeBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:35/255.0 green:168/255.0 blue:107/255.0 alpha:1] forState:UIControlStateNormal];
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:button];
        btn.tintColor = [UIColor colorWithRed:35/255.0 green:168/255.0 blue:107/255.0 alpha:1];
        self.navigationItem.rightBarButtonItem = btn;
        btn;
    });
    
    
    _alumbTable = ({
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = NO;
        [self.view addSubview:tableView];
        tableView;
    });
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma  mark -- TabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _alubms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"PhotoAlbumCell";
    PhotoAlbumCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[PhotoAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadPhotoAlbumData:[_alubms objectAtIndex:indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.alumbTable deselectRowAtIndexPath:indexPath animated:YES];
    PHAssetCollection * asset = [_alubms objectAtIndex:indexPath.row];
    if (self.callBack) {
        self.callBack(asset);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    /*
    ZZPhotoPickerViewController *photopickerController = [[ZZPhotoPickerViewController alloc]initWithNibName:nil bundle:nil];
    photopickerController.PhotoResult = self.photoResult;
    photopickerController.selectNum = self.selectNum;
    
    photopickerController.fetch = [self.datas GetFetchResult:[_alubms objectAtIndex:indexPath.row]];
    photopickerController.isAlubSeclect = YES;
    
    [self.navigationController pushViewController:photopickerController animated:YES];
     */
}

+ (void)showAlbumViewController:(UIViewController *)vc callBack:(seletctBack)callBack{
    PhotoAlbumViewController *avc = [[PhotoAlbumViewController alloc]init];
    avc.callBack = callBack;
    __weak typeof(vc)  weakVC = vc;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:avc];
    [weakVC presentViewController:nav animated:YES completion:nil];

}



@end
