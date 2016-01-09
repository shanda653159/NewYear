//
//  CustomHeaderView.m
//  HappyPurchase
//
//  Created by LD on 15/12/10.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "CustomHeaderView.h"
#import "MyImageView.h"
#import "MyButton.h"
#import "JiukuaijiuViewController.h"
#import "WorthViewController.h"
#import "HotViewController.h"
#import "ChooseViewController.h"
#import "StyleViewController.h"
#import "HeaderModel.h"

typedef void(^MyBlock)(void);

@interface CustomHeaderView ()<UIScrollViewDelegate>
{
    NSArray *_urlArr,*_titleArr;
    NSTimer *_timer;
}

@property (nonatomic,strong) NSMutableArray *imageArr;

@property (nonatomic,strong) MyImageView *imageView;

@property (nonatomic,strong) MyButton *button;

@property (nonatomic,copy) MyBlock block;

@property (nonatomic,strong) UIScrollView *sv;

@property (nonatomic,strong) UIPageControl *pc;

@property (nonatomic,assign) NSInteger count;

@end

/*自定义组头视图*/
@implementation CustomHeaderView

-(void)setDataWithImage:(NSMutableArray *)imageArr andTitle:(NSArray *)titleArr andUrl:(NSArray *)urlArr{

    self.imageArr = [imageArr mutableCopy];
    _urlArr = [urlArr mutableCopy];
    _titleArr = [titleArr mutableCopy];
    
    self.block();
}

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        __weak typeof(self)weakSelf = self;
        
        self.block = ^{
            
            [weakSelf createScrollView];
            
            [weakSelf createPageControl];
            
            [weakSelf createButton];
            
            [weakSelf createImgView];
            
        };
        
        //创建一个定时器，让组头滚动视图自动滚动
        _timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        //暂停定时器
        _timer.fireDate = [NSDate distantFuture];
        
        [self performSelector:@selector(play) withObject:nil afterDelay:4.0];
        
        self.count = 1;
    }
    return self;
}
-(void)play{
    //启动定时器
    _timer.fireDate = [NSDate distantPast];
}
//创建scrollView滚动头视图
-(void)createScrollView{
    
    _sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 140)];
    
    _sv.delegate = self;
    _sv.contentSize = CGSizeMake(KMainScreenWidth * (self.imageArr.count+2), 140);
    _sv.pagingEnabled = YES;
    _sv.bounces = NO; //无弹簧效果
    _sv.showsHorizontalScrollIndicator = NO;
    
    //给scrollView添加imageview的时候多加两张，让图片可以循环滚动
    for (int j = 0; j<self.imageArr.count+2; j++) {
        
        if (j == 0) {
            
            self.imageView = [[MyImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 140)];
            
            self.imageView.title = [self.imageArr[self.imageArr.count-1] title];
            self.imageView.linkUrl = [self.imageArr[self.imageArr.count-1] link];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageArr[self.imageArr.count-1] iphoneimg]]placeholderImage:[UIImage imageNamed:@"jiazai"]];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            
            self.imageView.userInteractionEnabled = YES;
            [self.imageView addGestureRecognizer:tap];
            
            [_sv addSubview:self.imageView];
        }else if (j == self.imageArr.count+1){
            
            self.imageView = [[MyImageView alloc]initWithFrame:CGRectMake(KMainScreenWidth*j, 0, KMainScreenWidth, 140)];
            
            self.imageView.title = [self.imageArr[0] title];
            self.imageView.linkUrl = [self.imageArr[0] link];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageArr[0] iphoneimg]]placeholderImage:[UIImage imageNamed:@"jiazai"]];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            
            self.imageView.userInteractionEnabled = YES;
            [self.imageView addGestureRecognizer:tap];
            
            [_sv addSubview:self.imageView];
        }else{
           
            self.imageView = [[MyImageView alloc]initWithFrame:CGRectMake(KMainScreenWidth*j, 0, KMainScreenWidth, 140)];
            
            self.imageView.title = [self.imageArr[j-1] title];
            self.imageView.linkUrl = [self.imageArr[j-1] link];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageArr[j-1] iphoneimg]]placeholderImage:[UIImage imageNamed:@"jiazai"]];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            
            self.imageView.userInteractionEnabled = YES;
            [self.imageView addGestureRecognizer:tap];
            
            [_sv addSubview:self.imageView];
        }
    }
    //偏移量:(默认是0)
    _sv.contentOffset = CGPointMake(KMainScreenWidth, 0);
    [self addSubview:_sv];
}
//创建scrollView的pageController
- (void)createPageControl{
    _pc = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 120, KMainScreenWidth, 20)];
    
    _pc.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    // 点数:
    _pc.numberOfPages = self.imageArr.count;
    // 当前第几个点:
    _pc.currentPage = 0;
    // 点的颜色:
    _pc.pageIndicatorTintColor = [UIColor whiteColor];
    // 当前点颜色:
    _pc.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:0.8];
    // 添加目标对象:
    [_pc addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:_pc];
}
//pageController回调方法
- (void)changePage:(UIPageControl *)pc{
    
    [self.sv setContentOffset:CGPointMake((pc.currentPage + 1) * KMainScreenWidth, 0) animated:YES];

    _count = pc.currentPage + 1;
}
//创建滚动头视图下的4个按钮
-(void)createButton{

    for (int i = 0; i < _urlArr.count; i++) {
        
        self.button = [MyButton buttonWithType:UIButtonTypeCustom];
        
        self.button.frame = CGRectMake(KMainScreenWidth/9.4*(2*i+1), 150, KMainScreenWidth/7, KMainScreenWidth/9);
        
        [self.button setTitle:_titleArr[i] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:11];
        self.button.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:0.7];
        
        self.button.linkUrl = _urlArr[i];
        self.button.tag = i+1;
        [self.button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        self.button.layer.cornerRadius = 12.0f;
        
        [self addSubview:self.button];
    }
}
//创建4个按钮下面的3个imageView
-(void)createImgView{

    for (int i = 0; i < 3; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(((KMainScreenWidth-5)/3+2.5)*i, 160+KMainScreenWidth/9, (KMainScreenWidth-5)/3, (KMainScreenWidth-5)/3)];
        
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2:)];
        
        imageView.tag = 10+i;
        
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap2];
        
        [self addSubview:imageView];
    }
}
//scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //循环移动:
    if (scrollView.contentOffset.x / KMainScreenWidth == 0) { //第一张
        
        scrollView.contentOffset = CGPointMake(KMainScreenWidth * self.imageArr.count, 0); //瞬间切换倒数第二张;
        
    }else if (scrollView.contentOffset.x / KMainScreenWidth == self.imageArr.count+1){ //最后一张
        
        scrollView.contentOffset = CGPointMake(KMainScreenWidth, 0); //瞬间切换到第二张;
    }

    _pc.currentPage = scrollView.contentOffset.x / KMainScreenWidth - 1;

    _count = _pc.currentPage + 1;
}
//定时器回调方法
-(void)updateTimer{
    
    self.count++;

    if (self.count == self.imageArr.count+1) {
        
        self.count = 1;
        
        self.sv.contentOffset = CGPointMake(0, 0);
    }

    [_sv setContentOffset:CGPointMake(KMainScreenWidth * self.count-1, 0) animated:YES];
    
    _pc.currentPage = _count - 1;
}
//通过view拿到对应的viewController
- (UIViewController *)viewController {
    
    for (UIView *next = [self superview]; next; next = next.superview) {
        
        UIResponder *nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


#pragma mark - 组头视图中各种事件
//滚动头视图手势
-(void)tap:(UITapGestureRecognizer *)tap{
    
    MyImageView *imgView = (id)tap.view;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    WebViewController *webViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    
    [webViewCtl.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imgView.linkUrl]]];
    
    webViewCtl.navigationItem.title = imgView.title;
    
    [[[self viewController] navigationController] pushViewController:webViewCtl animated:YES];
}
//9块9、每日十件、限时抢、值得买 按钮事件
-(void)clickAction:(MyButton *)button{
    
    if (button.tag == 3) {  //限时抢
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        WebViewController *webViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        
        [webViewCtl.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:button.linkUrl]]];
        
        webViewCtl.navigationItem.title = button.titleLabel.text;
        
        [[[self viewController] navigationController] pushViewController:webViewCtl animated:YES];
    }else if (button.tag == 1){  //9块9
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        JiukuaijiuViewController *jkjCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"JiukuaijiuViewController"];
        
        jkjCtl.linkUrl = button.linkUrl;
        
        jkjCtl.navigationItem.title = button.titleLabel.text;
        
        [[[self viewController] navigationController] pushViewController:jkjCtl animated:YES];
    }else if (button.tag == 2){  //值得买
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        WorthViewController *worthCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"WorthViewController"];
        
        worthCtl.linkUrl = button.linkUrl;
        
        worthCtl.navigationItem.title = button.titleLabel.text;
        
        [[[self viewController] navigationController] pushViewController:worthCtl animated:YES];
    }else if (button.tag == 4){  //每日十件
        
        [self showAlertView:@"敬请期待~"];
    }
}
//4个按钮下面的三个imageView的手势
-(void)tap2:(UITapGestureRecognizer *)tap{
    
    UIImageView *imgView = (id)tap.view;
    
    if (imgView.tag == 10) { //本周热卖
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        HotViewController *hotCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"HotViewController"];
        
        hotCtl.navigationItem.title = @"本周热卖";
        
        [[[self viewController] navigationController] pushViewController:hotCtl animated:YES];
        
    }else if (imgView.tag == 11){ //物色
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ChooseViewController *chooseCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"ChooseViewController"];
        
        chooseCtl.navigationItem.title = @"物色";
        
        [[[self viewController] navigationController] pushViewController:chooseCtl animated:YES];
        
    }else if (imgView.tag == 12){ //爆款
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        StyleViewController *styleCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"StyleViewController"];
        
        styleCtl.navigationItem.title = @"爆款";
        
        [[[self viewController] navigationController] pushViewController:styleCtl animated:YES];
    }
}
//提示弹窗
-(void)showAlertView:(NSString *)message{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertView show];
}
@end
