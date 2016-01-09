//
//  WorthViewController.m
//  HappyPurchase
//
//  Created by LD on 15/12/9.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "HotViewController.h"
#import "HotModel.h"
#import "HotCell.h"


@interface HotViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end


@implementation HotViewController

-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //定制返回按钮
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 0, 50, 44);
    [but setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBut = [[UIBarButtonItem alloc]initWithCustomView:but];
    
    self.navigationItem.leftBarButtonItem = backBut;
    
    [self refreshAndLoadMoreData];
    
    [self getRequestData];
    
}
//返回
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}


#pragma mark - 请求网络数据
//检测网络状态
-(void)updateNetStatus{

    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //开始检测
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            //无网络
            [self showAlertView:@"没网,大虾请检查网络"];
            
        }else{
            //有网络
            [self getRequestData];
        }
    }];
}
//请求网络数据
-(void)getRequestData{
    
    //提示正在请求数据
    [LDProgressView showViewTo:self.view];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [LDHttpManager getRequestWithURL:KHot_URL andParams:nil compeletionBlock:^(NSURLResponse *response, NSError *error, id obj) {
        
        //清除旧数据
        [self.dataArr removeAllObjects];
        
        if (error) {
            
            [self showAlertView:@"请求数据失败"];
            //请求数据失败也应该移除加载视图然后重新请求
            [LDProgressView hidesViewFrom:self.view];
            
        }else{
            
            for (NSDictionary *dic in obj[@"list"]) {
                
                HotModel *model = [HotModel new];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [self.dataArr addObject:model];
            }
            
            //刷新UI
            [self.collectionView reloadData];
            
            //隐藏加载视图，表示请求数据完毕
            [LDProgressView hidesViewFrom:self.view];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [self endRefresh];

        }
    }];
    
}
//警告弹窗
-(void)showAlertView:(NSString *)message{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertView show];
}


#pragma mark - 上下拉刷新加载
-(void)refreshAndLoadMoreData{
    
    //添加头部视图
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getRequestData];
    }];
    
    //添加尾部视图
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self getRequestData];
    }];
}
//结束刷新
-(void)endRefresh{
    
    [self.collectionView.header endRefreshing];
    [self.collectionView.footer endRefreshing];
}


#pragma mark - collectionView代理方法：
//返回collectionView的行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
//定制cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotCell" forIndexPath:indexPath];
    
    if (self.dataArr.count != 0) {
        [cell refreshUI:self.dataArr[indexPath.row]];
    }
    
    return cell;
}
//返回单个cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //一个cell的size
    return CGSizeMake(KMainScreenWidth*175/375, KMainScreenHeight*275/667);
}
//点击cell查看详情
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //?id=45337537374&app_id=45371494&app_oid=cc37115bd963a89b50cce7602a92771a4f40c9b2&app_version=1.0&app_channel=appstore&sche=fenbanjiazyj
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    WebViewController *webViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    
    [webViewCtl.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&app_id=45371494&app_oid=cc37115bd963a89b50cce7602a92771a4f40c9b2&app_version=1.0&app_channel=appstore&sche=fenbanjiazyj",KDetail_URL,[self.dataArr[indexPath.row] num_iid]]]]];
    
    webViewCtl.navigationItem.title = @"商品详情";
    
    [self.navigationController pushViewController:webViewCtl animated:YES];
    
}

@end
