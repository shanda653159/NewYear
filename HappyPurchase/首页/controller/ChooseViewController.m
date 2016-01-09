//
//  ChooseViewController.m
//  HappyPurchase
//
//  Created by 雷东 on 15/12/9.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "ChooseViewController.h"
#import "ChooseModel.h"
#import "ChooseCell.h"

@interface ChooseViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,assign) NSInteger page;

@end

@implementation ChooseViewController

-(NSMutableArray *)dataArr{

    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = -1;
    
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
    
    //?control=tianmao&model=get_sec_ten_one&page=-1
    [LDHttpManager getRequestWithURL:KChoose_URL andParams:@{@"control":@"tianmao",@"model":@"get_sec_ten_one",@"page":[NSString stringWithFormat:@"%ld",self.page]} compeletionBlock:^(NSURLResponse *response, NSError *error, id obj) {
        
        if (!self.tableView.mj_footer.isRefreshing) {
            
            //清除旧数据
            [self.dataArr removeAllObjects];
        }
        
        if (error) {
            
            [self showAlertView:@"请求数据失败"];
            //请求数据失败也应该移除加载视图然后重新请求
            [LDProgressView hidesViewFrom:self.view];
            
        }else{
            
            for (NSDictionary *dic in obj[@"data"]) {
                
                ChooseModel *model = [ChooseModel new];
                
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = -1;
        [self getRequestData];
    }];
    
    
    //添加尾部视图
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page++;
        [self getRequestData];
    }];
}

//结束刷新
-(void)endRefresh{
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


#pragma mark - tableView代理方法
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

//定制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseCell"];
    
    //判断当数据数组不为空才刷新，要不然程序可能会崩溃
    if (self.dataArr.count != 0) {
        [cell refreshUI:self.dataArr[indexPath.row]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//选择某一行cell时，进入详情页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *host = @"http://zhekou.repai.com/lws/wangyu/index.php?control=tianmao&model=get_sec_ten_two_view&id=";
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    WebViewController *webViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    
    [webViewCtl.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host,[self.dataArr[indexPath.row] topicContentId]]]]];
    
    webViewCtl.navigationItem.title = [self.dataArr[indexPath.row] title];
    
    [self.navigationController pushViewController:webViewCtl animated:YES];
    
}

@end
