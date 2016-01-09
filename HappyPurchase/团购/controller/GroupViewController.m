//
//  GroupViewController.m
//  HappyPurchase
//
//  Created by 雷东 on 15/12/12.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupModel.h"
#import "GroupCell.h"

@interface GroupViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end


@implementation GroupViewController

-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.rowHeight = 200;
    
    [self refreshAndLoadMoreData];
    
    [self getRequestData];
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
    
    [LDHttpManager getRequestWithURL:KGroupon_URL andParams:nil compeletionBlock:^(NSURLResponse *response, NSError *error, id obj) {
        
        if (error) {
            
            [self showAlertView:@"请求数据失败"];
            //请求数据失败也应该移除加载视图然后重新请求
            [LDProgressView hidesViewFrom:self.view];
            
        }else{
            
            //清除旧数据
            [self.dataArr removeAllObjects];
            
            for (NSDictionary *dic in obj[@"data"]) {
                
                GroupModel *model = [GroupModel new];
                
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
    
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    
    //判断当数据数组不为空才刷新，要不然程序可能会崩溃
    if (self.dataArr.count != 0) {
        [cell refreshUI:self.dataArr[indexPath.row]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//选择某一行cell时，查看详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    WebViewController *webViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    
    [webViewCtl.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:KJutaobao_URL]]];
    
    webViewCtl.navigationItem.title = @"精品团购";
    
    [self.navigationController pushViewController:webViewCtl animated:YES];
    
}

@end
