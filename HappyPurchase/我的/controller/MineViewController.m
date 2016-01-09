//
//  MineViewController.m
//  HappyPurchase
//
//  Created by 雷东 on 15/12/13.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "HomePageModel.h"
#import "HeaderModel.h"
#import "OverflowModel.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSInteger _num,_num1;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) UIImageView *headerView;

@property (nonatomic,strong) UIActivityIndicatorView *acView;

@end

@implementation MineViewController

-(NSManagedObjectContext *)managedObjectContext{
    
    return [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
}

-(UIActivityIndicatorView *)acView{
    
    if (!_acView) {
        _acView = [UIActivityIndicatorView new];
    }
    return _acView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
    [self createHeader];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    self.tableview.rowHeight = 55;
}
//显示导航栏
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
//隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
//创建header
-(void)createHeader{

    //给tableView添加头视图
    self.headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -200, KMainScreenWidth, 200)];
    
    self.headerView.image = [UIImage imageNamed:@"header.jpg"];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.center = CGPointMake(KMainScreenWidth/2, 100);
    label.text = @"下拉有惊喜哦";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    
    [self.headerView addSubview:label];
    
    [self.tableview addSubview:self.headerView];
    
    //避免headerView将cell挡住,将它放到子视图最后一层
    [self.tableview sendSubviewToBack:self.headerView];
    
    //改变tableView的内嵌值
    self.tableview.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
    
}
//tableView滚动时回调的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < -200) {

        //position 相当于UIView的center
        self.headerView.layer.position = CGPointMake(KMainScreenWidth / 2.0,  scrollView.contentOffset.y / 2.0);
        
        //设置一个放大系数
        CGFloat scale = fabs(scrollView.contentOffset.y) / 200;
        
        //触发放大缩小
        self.headerView.transform = CGAffineTransformMakeScale(scale, scale);
        
    }
}
//定时器回调方法
-(void)updateTimer{
    
    MineCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.titleLabel.text = @"我的淘宝   ";
    _num++;
    for (int i = 0; i <= _num; i++) {
        
        cell.titleLabel.text = [cell.titleLabel.text stringByAppendingString:@">"];
        
        if (_num == 3) {
            _num = 0;
        }
    }
    
    MineCell *cell1 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell1.titleLabel.text = @"购物车      ";
    _num1++;
    for (int i = 0; i <= _num1; i++) {
        
        cell1.titleLabel.text = [cell1.titleLabel.text stringByAppendingString:@">"];
        
        if (_num1 == 3) {
            _num1 = 0;
        }
    }
}


#pragma mark - tableview代理方法
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}
//定制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MineCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell1"];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell2"];
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell3"];
            break;
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell4"];
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//选择cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) { //我的淘宝
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        WebViewController *webViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        
        [webViewCtl.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:KTaobao_URL]]];
        
        webViewCtl.navigationItem.title = @"我的淘宝";
        
        [self.navigationController pushViewController:webViewCtl animated:YES];
        
        
    }else if (indexPath.row == 1){ //购物车
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        WebViewController *webViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        
        [webViewCtl.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:KBag_URL]]];
        
        webViewCtl.navigationItem.title = @"购物车";
        
        [self.navigationController pushViewController:webViewCtl animated:YES];
    }else if (indexPath.row == 3){ //清除缓存
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确定清除本地缓存么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        alertView.delegate = self;
        
        [alertView show];
        
    }else if (indexPath.row == 4){ //关于我们
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"大雷出品，必属精品\n\n   © 我为购狂" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView show];
    }
}
//点击清除缓存确定按钮事件:清除数据库中的数据
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //确定按钮
    if (buttonIndex == 1) {
        //提示正在清理缓存
        [LDProgressView showViewTo:self.view];
        
        //删除首页数据库中的数据
        for (HomePageModel *model in [self searchHomePageData]) {
                
            [[self managedObjectContext] deleteObject:model];
            
            [[self managedObjectContext] save:nil];
        }
        //删除首页组头视图数据库中的数据
        for (HeaderModel *model in [self searchHeaderData]) {
            
            [[self managedObjectContext] deleteObject:model];
            
            [[self managedObjectContext] save:nil];
        }
        //删除超值购数据库中的数据
        for (OverflowModel *model in [self searchOverflowData]) {
            
            [[self managedObjectContext] deleteObject:model];
            
            [[self managedObjectContext] save:nil];
        }
        //缓存清理完毕
        [LDProgressView hidesViewFrom:self.view];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"清除缓存完毕!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
     
    }
}
//查询HomePageModel数据：
-(NSArray *)searchHomePageData{
    
    //查询数据库
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HomePageModel" inManagedObjectContext:[self managedObjectContext]];
    
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    
    return [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
}
//查询HeaderModel数据：
-(NSArray *)searchHeaderData{
    
    //查询数据库
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HeaderModel" inManagedObjectContext:[self managedObjectContext]];

    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    
    return [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
}
//查询OverflowModel数据：
-(NSArray *)searchOverflowData{
    
    //查询数据库
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OverflowModel" inManagedObjectContext:[self managedObjectContext]];
    
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    
    return [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
}

@end
