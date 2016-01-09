//
//  WorthViewController.m
//  HappyPurchase
//
//  Created by LD on 15/12/9.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "WorthViewController.h"
#import "WorthModel.h"
#import "WorthCell.h"

@interface WorthViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSMutableArray *matchArr;

@end


@implementation WorthViewController

-(NSMutableArray *)matchArr{

    if (!_matchArr) {
        _matchArr = [NSMutableArray new];
    }
    return _matchArr;
}

-(NSMutableArray *)dataArr{

    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //定制返回按钮
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 0, 50, 44);
    [but setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBut = [[UIBarButtonItem alloc]initWithCustomView:but];
    self.navigationItem.leftBarButtonItem = backBut;
    
    self.tableView.rowHeight = 158;
    
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


#pragma mark - 网络数据
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
    
    [LDHttpManager getRequestWithURL:self.linkUrl andParams:nil compeletionBlock:^(NSURLResponse *response, NSError *error, id obj) {
        
        //清除旧数据
        [self.dataArr removeAllObjects];
        
        if (error) {
            
            [self showAlertView:@"请求数据失败"];
            //请求数据失败也应该移除加载视图然后重新请求
            [LDProgressView hidesViewFrom:self.view];
            
        }else{
            
            for (NSDictionary *dic in obj[@"data"]) {
                
                WorthModel *model = [WorthModel new];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [self.dataArr addObject:model];
            }
            //刷新UI
            [self.tableView reloadData];
            
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
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getRequestData];
    }];
    
    
    //添加尾部视图
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self getRequestData];
    }];
}
//结束刷新
-(void)endRefresh{
    
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}


#pragma mark - tableView代理方法
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
//定制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WorthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorthCell"];
    
    //判断当数据数组不为空才刷新，要不然程序可能会崩溃
    if (self.dataArr.count != 0) {
        [cell refreshUI:self.dataArr[indexPath.row]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//选择某一行cell时，查看详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //?id=45337537374&app_id=45371494&app_oid=cc37115bd963a89b50cce7602a92771a4f40c9b2&app_version=1.0&app_channel=appstore&sche=fenbanjiazyj
    
    //http://app.api.repaiapp.com/sx/yangshijie/jiekou/chaozhigou/zhidemai_show.php?type=10&app_id=45371494&app_oid=cc37115bd963a89b50cce7602a92771a4f40c9b2&app_version=1.0&app_channel=appstore&sche=fenbanjiazyj
    
//    if ([[self.dataArr[indexPath.row] more] isEqualToString:@"10"]) {
//        
//        [LDHttpManager getRequestWithURL:@"http://app.api.repaiapp.com/sx/yangshijie/jiekou/chaozhigou/zhidemai_show.php?type=10&app_id=45371494&app_oid=cc37115bd963a89b50cce7602a92771a4f40c9b2&app_version=1.0&app_channel=appstore&sche=fenbanjiazyj" andParams:nil compeletionBlock:^(NSURLResponse *response, NSError *error, id obj) {
//            
//            NSLog(@"%@",obj);
//        }];
//        
//    }else{
    
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        WebViewController *webViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        
        [webViewCtl.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&app_id=45371494&app_oid=cc37115bd963a89b50cce7602a92771a4f40c9b2&app_version=1.0&app_channel=appstore&sche=fenbanjiazyj",KDetail_URL,[self.dataArr[indexPath.row] num_iid]]]]];
        
        webViewCtl.navigationItem.title = @"商品详情";
        
        [self.navigationController pushViewController:webViewCtl animated:YES];
//    }
}
//抢购按钮事件
- (IBAction)purchaseAction:(UIButton *)sender {
    
    [self showAlertView:@"快点击图片抢购吧~"];
}


@end
