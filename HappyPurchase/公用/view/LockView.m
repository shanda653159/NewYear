//
//  LockView.m
//  手势密码解锁
//
//  Created by 雷东 on 15/12/26.
//  Copyright © 2015年 雷东. All rights reserved.
//

#import "LockView.h"

#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height

@interface LockView ()

@property (nonatomic,strong) NSMutableArray *btnArr;

@property (nonatomic,assign) CGPoint currentPoint;

@end

@implementation LockView

-(NSMutableArray *)btnArr{

    if (!_btnArr) {
        _btnArr = [NSMutableArray new];
    }
    return _btnArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createBtn];
    }
    return self;
}

-(void)createBtn{

    for (int i = 0; i < 9; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat margin = (KWidth - 70 * 3) / 4;
        btn.frame = CGRectMake(margin + i % 3 * (70 + margin), margin + i / 3 * (70 + margin), 70, 70);
        
        btn.layer.cornerRadius = 35.0f;
        
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        
        btn.userInteractionEnabled = NO;
        
        btn.tag = i + 1;
        
        [self addSubview:btn];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    CGPoint beginPoint = [self getTouchPoint:touches];
    
    UIButton *btn = [self getTouchButton:beginPoint];
    
    if (btn && !btn.selected) {
        
        [self.btnArr addObject:btn];
        
        btn.selected = YES;
    }
    
//    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    CGPoint movePoint = [self getTouchPoint:touches];
    
    UIButton *btn = [self getTouchButton:movePoint];
    
    if (btn && !btn.selected) {
        
        [self.btnArr addObject:btn];
        
        btn.selected = YES;
    }
    
    self.currentPoint = movePoint;
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    for (UIButton *btn in self.btnArr) {
        
        btn.selected = NO;
    }
    
    NSMutableString *password = [NSMutableString string];
    
    for (UIButton *btn in self.btnArr) {
        
        [password appendFormat:@"%ld",btn.tag];
    }
//    NSLog(@"%@",password);
    
    if ([self.delegate respondsToSelector:@selector(unlockWithPassword:)]) {
        
        [self.delegate unlockWithPassword:password];
    }
    
    //清空currentPoint（置为初始值）
    self.currentPoint = CGPointZero;

//    [self.btnArr makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    
    [self.btnArr removeAllObjects];
    
    //重绘
    [self setNeedsDisplay];
}

-(CGPoint)getTouchPoint:(NSSet<UITouch *> *)touches{

    UITouch *touch = [touches anyObject];
    
    return [touch locationInView:touch.view];
}

-(UIButton *)getTouchButton:(CGPoint)point{

    for (UIButton *btn in self.subviews) {
        
        if (CGRectContainsPoint(btn.frame, point)) {
            
            return btn;
        }
        
    }
    return nil;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    //为了严谨，清空上下文(否则view用默认颜色的时候有缓存，会出现很多线)
    CGContextClearRect(ref, rect);
    
    for (int i = 0; i < self.btnArr.count; i++) {
        
        UIButton *btn = self.btnArr[i];
        if (i == 0) {
            
            CGContextMoveToPoint(ref, btn.center.x, btn.center.y);
        }else{
        
            CGContextAddLineToPoint(ref, btn.center.x, btn.center.y);
        }
    }
    
    //当currentPoint不为初始point的时候才连线
    if (!CGPointEqualToPoint(self.currentPoint, CGPointZero) && self.btnArr.count != 0) {
        
        CGContextAddLineToPoint(ref, self.currentPoint.x, self.currentPoint.y);
    }
    
    //设置线条粗细
    CGContextSetLineWidth(ref, 8.0);
    //设置颜色
    [[UIColor lightGrayColor] set];
    //设置连线转角处为圆形
    CGContextSetLineJoin(ref, kCGLineJoinRound);
    CGContextSetLineCap(ref, kCGLineCapRound);
    
    CGContextStrokePath(ref);
}

@end
