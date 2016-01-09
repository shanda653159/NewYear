//
//  WelcomeViewController.m
//  HappyPurchase
//
//  Created by LD on 15/12/15.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LockViewController.h"
#import "LockView.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIPageControl *pc;

@property (nonatomic,assign) BOOL notFirst;

@end

@implementation WelcomeViewController

-(void)viewDidLoad{

    //创建首次使用欢迎界面
    NSUserDefaults *use = [NSUserDefaults standardUserDefaults];
    
    if (![use objectForKey:@"first" ]) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        
        _scrollView.delegate = self;
        
        _scrollView.contentSize = CGSizeMake(KMainScreenWidth*5, KMainScreenHeight);
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        
        [self.view addSubview:_scrollView];
        
        for (int i = 0; i<5; i++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KMainScreenWidth *i, 0, KMainScreenWidth, KMainScreenHeight)];
            
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"launch_%d.jpg",i+1]];
            
            if (i == 4) {
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                
                [btn setTitle:@"欢迎使用" forState:UIControlStateNormal];
                
                [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
                
                btn.backgroundColor = [UIColor clearColor];
                
                btn.layer.cornerRadius = 18.0f;
                btn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1].CGColor;
                btn.layer.borderWidth = 2.0;
                
                btn.frame = CGRectMake(KMainScreenWidth/2-60, KMainScreenHeight/2+70, 120, 35);
                
                [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
                
                [imageView addSubview:btn];
                //打开人机交互开关
                imageView.userInteractionEnabled = YES;
                
            }else{
            
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                
                [btn setTitle:@"跳过" forState:UIControlStateNormal];
                
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                btn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
                
                btn.frame = CGRectMake(KMainScreenWidth-60, KMainScreenHeight-40, 50, 30);
                
                [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
                
                [imageView addSubview:btn];
                //打开人机交互开关
                imageView.userInteractionEnabled = YES;
            }
            
            [_scrollView addSubview:imageView];
        }
        
        //创建PageControl
        [self createPageControl];
        
    }else{
        
        self.notFirst = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    if (self.notFirst) {
        
        [self lockViewBegin];
    }
}
//跳过和欢迎使用按钮回调方法
- (void)clickBtn
{
    [UIView animateWithDuration:2.0f animations:^{
        
        _scrollView.alpha = 0;
        _scrollView.transform = CGAffineTransformRotate(_scrollView.transform, M_PI);
        _scrollView.transform = CGAffineTransformScale(_scrollView.transform, 2, 0.5);
        
    } completion:^(BOOL finished) {
        
        //移除scrollView
        [_scrollView removeFromSuperview];
        
        [_pc removeFromSuperview];
        
        //存储值，以免下次进入app还会进入到欢迎界面
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"first"];
        
        //进入到解锁界面
        [self lockViewBegin];
    }];
}
//进入解锁界面
-(void)lockViewBegin{

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LockViewController *lockCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"LockViewController"];
    
    lockCtl.view.alpha = 0;
    
    [self presentViewController:lockCtl animated:NO completion:^{
        
        [UIView animateWithDuration:1.0 animations:^{
            
            lockCtl.view.alpha = 1;
            
        }];
        
    }];
}
//创建scrollView的pageController
- (void)createPageControl{
    
    _pc = [[UIPageControl alloc] initWithFrame:CGRectMake(KMainScreenWidth/2-40, KMainScreenHeight-30, 80, 20)];
    // 点数:
    _pc.numberOfPages = 5;
    // 当前第几个点:
    _pc.currentPage = 0;
    // 点的颜色:
    _pc.pageIndicatorTintColor = [UIColor lightGrayColor];
    // 当前点颜色:
    _pc.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:0.8];
    // 添加目标对象:
    [_pc addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_pc];
}
//pageController回调方法
- (void)changePage:(UIPageControl *)pc{
    
    [self.scrollView setContentOffset:CGPointMake(pc.currentPage * KMainScreenWidth, 0) animated:YES];
}
//scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    _pc.currentPage = scrollView.contentOffset.x / KMainScreenWidth;
}

@end
