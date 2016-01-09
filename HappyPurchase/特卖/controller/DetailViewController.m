//
//  ShowViewController.m
//  HappyPurchase
//
//  Created by LD on 15/12/9.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailModel.h"
#import "DetailCell.h"

@interface DetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,assign) NSInteger start;

@end

@implementation DetailViewController

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
    
    //初始化刷新值
    self.start = 0;
    
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
//隐藏tabbar
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
//显示tabbar
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
    
    //?cid=50026302&start=0&sort=s&price=0,300  详情
    //?keyword=鼠标&start=0&sort=s&price=5,9999  搜索
    NSString *url,*params;
    if (self.isSearch) {
        
        url = KSearchGood_URL;
        //带有中文需要转换成UTF编码
        NSString *utf8Str = [self.keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params = [NSString stringWithFormat:@"keyword=%@&start=%ld&sort=s&price=5,9999",utf8Str,self.start];
        
    }else{
    
        url = KSubSpecial_URL;
        params = [NSString stringWithFormat:@"cid=%@&start=%ld&sort=s&price=5,9999",self.cid,self.start];
    }
    
    [LDHttpManager getRequestWithURL:[NSString stringWithFormat:@"%@?%@",url,params] andParams:nil compeletionBlock:^(NSURLResponse *response, NSError *error, id obj) {
        
        if (!self.collectionView.footer.isRefreshing) {
            //清除旧数据
            [self.dataArr removeAllObjects];
        }
        
        if (error) {
            
            [self showAlertView:@"请求数据失败"];
            //请求数据失败也应该移除加载视图然后重新请求
            [LDProgressView hidesViewFrom:self.view];
            
        }else{
            
            for (NSDictionary *dic in obj[@"list"]) {
                
                DetailModel *model = [DetailModel new];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [self.dataArr addObject:model];
            }
            
//            NSLog(@"%@",obj);
            
            if (self.isSearch && [obj[@"is_end"] integerValue] == 1){

                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"查无此类商品！请确认商品名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                alertView.delegate = self;
                
                [alertView show];
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
//提示弹窗
-(void)showAlertView:(NSString *)message{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    alertView.delegate = self;
    
    [alertView show];
}
//提示查无此类商品之后，按下确定按钮之后pop回到前一个页面
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - 上下拉刷新加载
-(void)refreshAndLoadMoreData{
    
    //添加头部视图
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.start = 0;
        [self getRequestData];
    }];
    
    //添加尾部视图
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.start += 30;
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
    
    DetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCell" forIndexPath:indexPath];
    
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
    
    [webViewCtl.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&app_id=45371494&app_oid=cc37115bd963a89b50cce7602a92771a4f40c9b2&app_version=1.0&app_channel=appstore&sche=fenbanjiazyj",KDetail_URL,[self.dataArr[indexPath.row] item_id]]]]];
    
    webViewCtl.navigationItem.title = @"商品详情";
    
    [self.navigationController pushViewController:webViewCtl animated:YES];

}

@end
