//
//  HomePageViewController.m
//  HappyPurchase
//
//  Created by 雷东 on 15/12/8.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "HomePageViewController.h"
#import "HeaderModel.h"
#import "CustomHeaderView.h"
#import "HomePageModel.h"
#import "HomePageCell.h"
#import "OverflowModel.h"
#import "MenuCell.h"


@interface HomePageViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
{
    CGPoint _point, _point2;
    NSArray *_menuArr,*_titleArr,*_urlArr;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//存数组头滚动视图数组
@property (nonatomic,strong) NSMutableArray *imageArr;

@property (nonatomic,strong) NSMutableArray *dataArr;
//collectionView的frame
@property (nonatomic,assign) CGRect rect;

@property (nonatomic,assign) NSInteger cid;
//collectionView左侧的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionlefting;
//collectionView右侧的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionRighting;

@property (nonatomic,strong) AppDelegate *app;

@end

@implementation HomePageViewController

-(AppDelegate *)app{

    return [UIApplication sharedApplication].delegate;
}

-(NSManagedObjectContext *)managedObjectContext{
    
    return [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
}

-(NSMutableArray *)dataArr{

    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

-(NSMutableArray *)imageArr{

    if (!_imageArr) {
        _imageArr = [NSMutableArray new];
    }
    return _imageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.app.isHomePage) {
        
        _titleArr = @[@"9.9&购",@"值得&买",@"限时&抢",@"每日十件"];
        _urlArr = @[FIRST_URL,SECOND_URL,THIRD_URL,FORTH_URL];
        
        [self.collectionView registerClass:[CustomHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        self.navigationItem.title = @"首页&爽歪歪";
    }else{
    
        self.navigationItem.title = @"捡宝&超值购";
    }
    
    //首页默认显示全部
    self.cid = 0;
    
    self.tableView.rowHeight = (KMainScreenHeight-64-49)/11;
    
    //让tableView默认选择第1个cell
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    self.tableView.layer.borderWidth = 1.0;
    self.tableView.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2].CGColor;
    
    _menuArr = @[@"全部",@"数码",@"女装",@"男装",@"家居",@"母婴",@"鞋包",@"配饰",@"美妆",@"美食",@"其他"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self refreshAndLoadMoreData];
    
    [self loadDataFromDatabase];
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
            
            if (self.app.isHomePage) {
                [self requestHeaderImage];
            }
        }
    }];
}
//请求网络数据
-(void)getRequestData{
    
    //提示正在请求数据
    [LDProgressView showViewTo:self.view];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *url;
    if (self.app.isHomePage) {
        
        url = KHomePage_URL;
    }else{
    
        url = KOverflow_URL;
    }
    
    //?cid=0
    [LDHttpManager getRequestWithURL:url andParams:@{@"cid":[NSString stringWithFormat:@"%ld",self.cid]} compeletionBlock:^(NSURLResponse *response, NSError *error, id obj) {
        
//        [ld hideViewFrom:self.view];
            
        if (self.app.isHomePage) {
            
            for (HomePageModel *model in [self searchFromDatabase]) {
                
                [[self managedObjectContext] deleteObject:model];
            }
        }else{
            
            for (OverflowModel *model in [self searchFromDatabase]) {
                
                [[self managedObjectContext] deleteObject:model];
            }
        }
        
        //清除旧数据
        [self.dataArr removeAllObjects];
        
        [[self managedObjectContext] save:nil];
        
        if (error) {
            
            [self showAlertView:@"请求数据失败"];
            //请求数据失败也应该移除加载视图然后重新请求
            [LDProgressView hidesViewFrom:self.view];
            
        }else{
            
            for (NSDictionary *dic in obj[@"list"]) {
                
                if (self.app.isHomePage) {
                    HomePageModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"HomePageModel" inManagedObjectContext:[self managedObjectContext]];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [self.dataArr addObject:model];
                }else{
                    
                    OverflowModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"OverflowModel" inManagedObjectContext:[self managedObjectContext]];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [self.dataArr addObject:model];
                }
                
                [[self managedObjectContext] save:nil];
                
            }
            
            //刷新UI
            [self.collectionView reloadData];
            
            //隐藏加载视图,说明数据加载完毕
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [LDProgressView hidesViewFrom:self.view];
            
            [self endRefresh];
        }
    }];
    
}
//获取滚动头视图
-(void)requestHeaderImage{
    
    [LDHttpManager getRequestWithURL:KScroll_URL andParams:nil compeletionBlock:^(NSURLResponse *response, NSError *error, id obj) {
        
        if (error) {
            
            [self showAlertView:@"请求数据失败"];
            
        }else{
            
            //参数为NO：清除本地所有数据
            for (HeaderModel *model in [self searchImageFromDatabase]) {
                
                [[self managedObjectContext] deleteObject:model];
            }
            
            //清除旧数据
            [self.imageArr removeAllObjects];
            
            [[self managedObjectContext] save:nil];
            
            for (NSDictionary *dic in obj[@"data"]) {
                
                HeaderModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"HeaderModel" inManagedObjectContext:[self managedObjectContext]];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [self.imageArr addObject:model];
                
                [[self managedObjectContext] save:nil];

            }
            
            //刷新UI
            [self.collectionView reloadData];
        }
    }];
}
//警告弹窗
-(void)showAlertView:(NSString *)message{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertView show];
}


#pragma mark - 上下拉刷新加载
//添加头部尾部视图
-(void)refreshAndLoadMoreData{
    
    //添加头部视图
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (self.app.isHomePage) {
            [self requestHeaderImage];
        }
        [self getRequestData];
    }];
    
    //添加尾部视图
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (self.app.isHomePage) {
            [self requestHeaderImage];
        }
        [self getRequestData];
    }];
}
//结束刷新
-(void)endRefresh{
    
    [self.collectionView.header endRefreshing];
    [self.collectionView.footer endRefreshing];
}


#pragma mark - 数据库相关
//从数据库拿数据
-(void)loadDataFromDatabase{
    
    //获取本地数据
    self.dataArr = [[self searchFromDatabase] mutableCopy];
    
    if (self.app.isHomePage) {
        
        self.imageArr = [[self searchImageFromDatabase] mutableCopy];
    }
    
    //刷新
    [self.collectionView reloadData];
    
    //判断网络状态
    [self updateNetStatus];
}
//查询数据：
-(NSArray *)searchFromDatabase{
    
    //查询数据库
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity;
    
    if (self.app.isHomePage) {
        
        entity = [NSEntityDescription entityForName:@"HomePageModel" inManagedObjectContext:[self managedObjectContext]];
    }else{
    
        entity = [NSEntityDescription entityForName:@"OverflowModel" inManagedObjectContext:[self managedObjectContext]];
    }
    
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    
    return [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
}
//查询数据(头视图)
-(NSArray *)searchImageFromDatabase{
    
    //查询数据库
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HeaderModel" inManagedObjectContext:[self managedObjectContext]];
    
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    
    return [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
}


#pragma mark - collectionView代理方法
//返回collectionView的行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
//定制cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageCell" forIndexPath:indexPath];
    
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

//返回组头视图:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if (self.app.isHomePage) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            CustomHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            
            for (UIView *view in header.subviews) {
                
                [view removeFromSuperview];
            }

            //把数据传到CustomHeaderView类中
            if (self.imageArr.count != 0) {
                [header setDataWithImage:self.imageArr andTitle:_titleArr andUrl:_urlArr];
            }
            
            return header;
        }
        
        return nil;
    }else{
    
        return nil;
    }
}
//返回头视图的高度:
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.app.isHomePage) {
        return CGSizeMake(160+KMainScreenWidth/9+(KMainScreenWidth-5)/3, 160+KMainScreenWidth/9+(KMainScreenWidth-5)/3);
    }else{
    
        return CGSizeMake(0, 0);
    }
}
//点击cell查看详情
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    //?id=45337537374&app_id=45371494&app_oid=cc37115bd963a89b50cce7602a92771a4f40c9b2&app_version=1.0&app_channel=appstore&sche=fenbanjiazyj
    
    if (self.app.isHomePage && indexPath.row == 0 && self.cid == 0) {
        
        [self showAlertView:@"请前往AppStore下载热拍,更多优惠一网打尽~"];
        
    }else{
            
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        WebViewController *webViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        
        [webViewCtl.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&app_id=45371494&app_oid=cc37115bd963a89b50cce7602a92771a4f40c9b2&app_version=1.0&app_channel=appstore&sche=fenbanjiazyj",KDetail_URL,[self.dataArr[indexPath.row] num_iid]]]]];
        
        webViewCtl.navigationItem.title = @"商品详情";
        
        [self.navigationController pushViewController:webViewCtl animated:YES];
    }
    
}


#pragma mark - tableView代理方法
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _menuArr.count;
}
//定制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    [cell setTitle:_menuArr[indexPath.row]];
    
    if (indexPath.row == 0 && self.cid == 0) {
        //给第一行cell的border和title一个默认颜色
        cell.titleLabel.layer.borderColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0].CGColor;
        cell.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    }
    else if (indexPath.row == 10 && self.cid == 10){
        //选中最后一行的时候也做特殊处理，否则的话最后一行颜色会出问题
        cell.titleLabel.layer.borderColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0].CGColor;
        cell.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    }
    
    MenuCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.cid inSection:0]];
    cell1.titleLabel.layer.borderColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0].CGColor;
    cell1.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//选择某一行时
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MenuCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];

    //选中某一行的时候改变border和title颜色
    cell.titleLabel.layer.borderColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0].CGColor;
    cell.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    
    //url中的cid，同时记录当前选中的tableView的row
    self.cid = indexPath.row;
    
    [self loadDataFromDatabase];
    
}
//取消选中某一行时
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    //选择取消时，border和title变回原来的颜色
    MenuCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];

    cell.titleLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cell.titleLabel.textColor = [UIColor darkGrayColor];
}


#pragma mark - 各种事件
//navigationItem按钮事件-->menu
- (IBAction)menuAction:(UIButton *)sender {
    
    _rect = self.collectionView.frame;
    
    if (_rect.origin.x == 0) {
        
        [UIView animateWithDuration:.5 animations:^{
            
            _rect.origin.x = 90;
            self.collectionView.frame = _rect;
            
        } completion:^(BOOL finished) {
            
            self.collectionlefting.constant = 90;
            self.collectionRighting.constant = -90;
        }];
        
    }else{
        
        [UIView animateWithDuration:.5 animations:^{

            _rect.origin.x = 0;
            self.collectionView.frame = _rect;
            self.collectionlefting.constant = 0;
            self.collectionRighting.constant = 0;
            
        }];
        
    }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    _point = [touch locationInView:self.collectionView];
//    NSLog(@"%f  %f",_point.x,_point.y);
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    _point2 = [touch locationInView:self.collectionView];
//    
//    if (_point2.x > _point.x) {
//        CGRect rect = self.collectionView.frame;
//        rect.origin.x = 100;
//        self.collectionView.frame = rect;
//    }
//    else if (_point2.x < _point.x) {
//        CGRect rect = self.collectionView.frame;
//        rect.origin.x = 0;
//        self.collectionView.frame = rect;
//    }
//}

@end
