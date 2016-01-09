//
//  SpecialSaleViewController.m
//  HappyPurchase
//
//  Created by LD on 15/12/11.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "SpecialSaleViewController.h"
#import "DetailViewController.h"
#import "SpecialSaleCell.h"
#import "SpecialSubCell.h"
#import "SpecialFirstCell.h"
#import "ChuangyiModel.h"
#import "JujiaModel.h"
#import "LingshiModel.h"
#import "MeizhuangModel.h"
#import "NanrenModel.h"
#import "NvrenModel.h"
#import "ShumaModel.h"
#import "TuijianModel.h"

@interface SpecialSaleViewController()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *leftCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *rightCollectionView;
//搜索控制器
@property (nonatomic,strong) UISearchController *searchCtl;
//搜索控制器的父视图
@property (nonatomic,strong) UIView *subView;

@property (nonatomic,strong) NSArray *titleArr;
//刷新右边collectionView的数据数组
@property (nonatomic,strong) NSMutableArray *dataArr;
//存放各种模型的数组
@property (nonatomic,strong)NSMutableArray *manArr;
@property (nonatomic,strong)NSMutableArray *tjArr;
@property (nonatomic,strong)NSMutableArray *lsArr;
@property (nonatomic,strong)NSMutableArray *womenArr;
@property (nonatomic,strong)NSMutableArray *smArr;
@property (nonatomic,strong)NSMutableArray *cyArr;
@property (nonatomic,strong)NSMutableArray *mzArr;
@property (nonatomic,strong)NSMutableArray *jjArr;

//rightCollectionView当前选中的item的indexPath.row
@property (nonatomic,assign) NSInteger currentRow;
//屏幕翻转时navigationBar的高度
@property (nonatomic,assign) CGFloat barHeight;

@end

@implementation SpecialSaleViewController

//懒加载
-(NSMutableArray *)manArr{

    if (!_manArr) {
        _manArr = [NSMutableArray new];
    }
    return _manArr;
}
-(NSMutableArray *)tjArr{
    
    if (!_tjArr) {
        _tjArr = [NSMutableArray new];
    }
    return _tjArr;
}
-(NSMutableArray *)lsArr{
    
    if (!_lsArr) {
        _lsArr = [NSMutableArray new];
    }
    return _lsArr;
}
-(NSMutableArray *)womenArr{
    
    if (!_womenArr) {
        _womenArr = [NSMutableArray new];
    }
    return _womenArr;
}
-(NSMutableArray *)smArr{
    
    if (!_smArr) {
        _smArr = [NSMutableArray new];
    }
    return _smArr;
}
-(NSMutableArray *)cyArr{
    
    if (!_cyArr) {
        _cyArr = [NSMutableArray new];
    }
    return _cyArr;
}
-(NSMutableArray *)mzArr{
    
    if (!_mzArr) {
        _mzArr = [NSMutableArray new];
    }
    return _mzArr;
}
-(NSMutableArray *)jjArr{
    
    if (!_jjArr) {
        _jjArr = [NSMutableArray new];
    }
    return _jjArr;
}

-(void)viewDidLoad{

    self.barHeight = 32;
    
    self.titleArr = @[@"推荐",@"创意",@"零食",@"美妆",@"男孩",@"女孩",@"数码",@"居家"];
    
    self.rightCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.leftCollectionView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.1];
    self.leftCollectionView.layer.borderWidth = 1.0;
    self.leftCollectionView.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.1].CGColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
////    让rightCollectionView默认选择第1个item
//    [self.rightCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    //创建搜索控制器
    [self createSearchCtl];
    
    [self getRequestData];
}


#pragma mark - 请求网络数据
//请求主数据
-(void)getRequestData{

    //提示正在请求数据
    [LDProgressView showViewTo:self.view];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [LDHttpManager getRequestWithURL:KSpecialSale_URL andParams:nil compeletionBlock:^(NSURLResponse *response, NSError *error, id obj) {
        
        if (error) {
            
            [self showAlertView:@"请求数据失败"];
            //请求数据失败也应该移除加载视图然后重新请求
            [LDProgressView hidesViewFrom:self.view];
            
        }else{
        
            for (NSDictionary *dic in obj[@"创意"]) {
                
                ChuangyiModel *model = [ChuangyiModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.cyArr addObject:model];
            }
            
            for (NSDictionary *dic in obj[@"居家"]) {
                
                JujiaModel *model = [JujiaModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.jjArr addObject:model];
            }
            
            for (NSDictionary *dic in obj[@"零食"]) {
                
                LingshiModel *model = [LingshiModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.lsArr addObject:model];
            }
            
            for (NSDictionary *dic in obj[@"美妆"]) {
                
                MeizhuangModel *model = [MeizhuangModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.mzArr addObject:model];
            }
            
            for (NSDictionary *dic in obj[@"男人"]) {
                
                NanrenModel *model = [NanrenModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.manArr addObject:model];
            }
            
            for (NSDictionary *dic in obj[@"女人"]) {
                
                NvrenModel *model = [NvrenModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.womenArr addObject:model];
            }
            
            for (NSDictionary *dic in obj[@"数码"]) {
                
                ShumaModel *model = [ShumaModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.smArr addObject:model];
            }
            
            for (NSDictionary *dic in obj[@"推荐"]) {
                
                TuijianModel *model = [TuijianModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.tjArr addObject:model];
            }
            
            self.dataArr = [self.tjArr mutableCopy];
            
            [self.rightCollectionView reloadData];
            
            //隐藏加载视图，表示请求数据完毕
            [LDProgressView hidesViewFrom:self.view];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }];
}
//警告弹窗
-(void)showAlertView:(NSString *)message{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertView show];
}


#pragma mark - collectionView代理方法
//返回行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (self.leftCollectionView == collectionView) {
        
        return self.titleArr.count;
        
    } else {
        
        return self.dataArr.count;
    }
    
}
//定制cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.leftCollectionView == collectionView) {
        
        SpecialSaleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpecialSaleCell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            
            //第一行时默认改变背景颜色和title颜色
            cell.titleLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:0.8];
            cell.titleLabel.textColor = [UIColor whiteColor];
        }
        
        
        [cell setTitle:self.titleArr[indexPath.row]];

        cell.layer.cornerRadius = 15.0;
        
        return cell;
        
    } else {
        
        if (indexPath.row == 0) {
            
            SpecialFirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpecialFirstCell" forIndexPath:indexPath];
            
            [cell refreshUI:self.dataArr[indexPath.row]];
            
            return cell;
        }
        
        SpecialSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpecialSubCell" forIndexPath:indexPath];

        [cell refreshUI:self.dataArr[indexPath.row]];
        
        return cell;
    }
    
}
//返回某个cell的size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (collectionView == self.rightCollectionView) {
        
        if (indexPath.row == 0) {
            
            return CGSizeMake(KMainScreenWidth-80-30, (KMainScreenWidth-80-60)/3+25);
        }
        
        return CGSizeMake((KMainScreenWidth-80-60)/3, (KMainScreenWidth-80-60)/3+25);
        
    }else{
    
        return CGSizeMake(60, 28);
    }
}
//选择某一行cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.leftCollectionView == collectionView) {
    
        self.currentRow = indexPath.row;
        
        //获取第一个item
        SpecialSaleCell *cell1 = (SpecialSaleCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        //先取消第一个item的默认颜色
        cell1.titleLabel.backgroundColor = [UIColor whiteColor];
        cell1.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        
        SpecialSaleCell *cell = (SpecialSaleCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        //选中某一行的时候改变背景颜色和title颜色
        cell.titleLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:0.8];
        cell.titleLabel.textColor = [UIColor whiteColor];
        
        //@"推荐",@"创意",@"零食",@"美妆",@"男孩",@"女孩",@"数码",@"居家"
        switch (indexPath.row) {
            case 0:
                self.dataArr = [self.tjArr mutableCopy];
                break;
            case 1:
                self.dataArr = [self.cyArr mutableCopy];
                break;
            case 2:
                self.dataArr = [self.lsArr mutableCopy];
                break;
            case 3:
                self.dataArr = [self.mzArr mutableCopy];
                break;
            case 4:
                self.dataArr = [self.manArr mutableCopy];
                break;
            case 5:
                self.dataArr = [self.womenArr mutableCopy];
                break;
            case 6:
                self.dataArr = [self.smArr mutableCopy];
                break;
            case 7:
                self.dataArr = [self.jjArr mutableCopy];
                break;
            default:
                break;
        }
        
        //刷新右边的collectionView
        [self.rightCollectionView reloadData];
        
    } else {
        
        if (indexPath.row == 0) {
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            WebViewController *webViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            
            [webViewCtl.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.dataArr[0] name]]]];
            
            //title设置为rithtCollectionView当前选中的item的title
            webViewCtl.navigationItem.title = _titleArr[self.currentRow];
            
            [self.navigationController pushViewController:webViewCtl animated:YES];
            
        }else{
        
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            DetailViewController *detailCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
            
            detailCtl.cid = [self.dataArr[indexPath.row] cid];
            
            detailCtl.navigationItem.title = [self.dataArr[indexPath.row] name];
            
            [self.navigationController pushViewController:detailCtl animated:YES];
        }
    }
}
//选择的那一行被移除选择状态时
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.leftCollectionView == collectionView) {
        
        SpecialSaleCell *cell = (SpecialSaleCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        
        //移除选中某一行的时候回到原本的背景和title颜色
        cell.titleLabel.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        
    }
}


#pragma mark - 搜索商品
//点击搜索按钮时的代理方法(搜索商品)
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
//    NSLog(@"%@",self.searchCtl.searchBar.text);
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DetailViewController *detailCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    //搜索的商品名称
    detailCtl.keyword = self.self.searchCtl.searchBar.text;
    //说明是搜索状态
    detailCtl.isSearch = YES;
    
    detailCtl.navigationItem.title = self.searchCtl.searchBar.text;
    
    [self.navigationController pushViewController:detailCtl animated:YES];
}


#pragma mark - 创建搜索栏
-(void)createSearchCtl{
    
    _subView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, 44)];
//    UIView *subView = [UIView new];
    
    //定义搜索栏
    self.searchCtl = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchCtl.delegate = self;
//    self.searchCtl.searchResultsUpdater = self;
    self.searchCtl.searchBar.delegate = self;
    
    //搜索栏里有个搜索条
    [self.searchCtl.searchBar sizeToFit];
    self.searchCtl.searchBar.frame = CGRectMake(0, 0, KMainScreenWidth, 44);
    
    self.searchCtl.searchBar.placeholder = @"更多喜爱商品搜搜看...";
    
    self.searchCtl.dimsBackgroundDuringPresentation = NO;
    
    //处于搜索状态时，不会隐藏导航栏。
    self.searchCtl.hidesNavigationBarDuringPresentation = NO;
    
    //界面跳转时，收起搜索栏。
    self.definesPresentationContext = YES;
    
    [_subView addSubview:self.searchCtl.searchBar];
    [self.view addSubview:_subView];
    
//    //可手动添加约束
//    _subView.translatesAutoresizingMaskIntoConstraints = NO;
//    //给subView添加约束
//    [_subView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.navigationController.navigationBar.mas_bottom).offset(0);
//        make.leading.equalTo(self.view).offset(0);
//        make.bottom.equalTo(self.rightCollectionView.mas_top).offset(0);
//        make.right.equalTo(self.view).offset(0);
////        make.height.mas_equalTo(44);
//    }];
//
//    //可手动添加约束
//    self.searchCtl.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
//    //给searchBar添加约束
//    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(subView).offset(0);
//        make.leading.equalTo(subView).offset(0);
//        make.bottom.equalTo(subView).offset(0);
//        make.right.equalTo(subView).offset(0);
//    }];
}

//-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
//
//    NSLog(@"%f",self.navigationController.navigationBar.frame.size.height);
////
//    _subView.frame = CGRectMake(0, self.barHeight+20, KMainScreenWidth, 44);
//    
//    [self.rightCollectionView reloadData];
//    
//    self.barHeight = self.navigationController.navigationBar.frame.size.height;
//}

#pragma mark - searchController代理方法
////更新搜索结果
//-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//    
//    NSLog(@"搜索");
//}
////搜索控制器收起时的代理方法
//-(void)didDismissSearchController:(UISearchController *)searchController{
//    
//    
//    NSLog(@"收起");
//}

@end
