//
//  LJCuteView.m
//  QQMessageCountDemo
//
//  Created by James on 16/4/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LJCuteView.h"

@implementation LJCuteView {
    //--------两个圆的半径----------
    CGFloat    _r1;
    CGFloat    _R2;
    //--------backView的圆心----------
    CGFloat    _x1;
    CGFloat    _y1;
    //--------frontView的圆心----------
    CGFloat    _x2;
    CGFloat    _y2;
    //圆心距离
    CGFloat    _centerDistance;
    //--------sin cos ----------------
    CGFloat    _sinDigree;
    CGFloat    _cosDigree;
    //--------6个点----------
    CGPoint    _pointA;
    CGPoint    _pointB;
    CGPoint    _pointC;
    CGPoint    _pointD;
    CGPoint    _pointO;
    CGPoint    _pointP;
    
    CGPoint    _initailPoint;
    CAShapeLayer   *_shapeLayer;
    
    UIView    *_backView;
    UIView    *_frontView;
    
    //填充颜色
    UIColor   *_fillCuteColor;
}



- (instancetype)initWithPoint:(CGPoint)point superView:(UIView *)superView {
    if (self = [super initWithFrame:CGRectMake(point.x, point.y, self.bubbleWidth, self.bubbleWidth)]) {
        
        _initailPoint = point;
        
        self.containerView = superView;
        [self.containerView addSubview:self];
        
    }
    return self;
}

- (void)setUp {
    _shapeLayer = [CAShapeLayer layer];
    
    self.backgroundColor = [UIColor clearColor];
    
    //原理是两个view重叠,拖拽时一个backView缩放, frontView进行位移 用shapeLayer 来填充
    _frontView = [[UIView alloc]initWithFrame:CGRectMake(_initailPoint.x, _initailPoint.y, self.bubbleWidth, self.bubbleWidth)];
    _R2 = _frontView.bounds.size.width * 0.5;
    _frontView.layer.cornerRadius = _R2;
    _frontView.backgroundColor = self.bubbleColor;
    
    
    _backView = [[UIView alloc]initWithFrame:_frontView.frame];
    _r1 = _backView.bounds.size.width * 0.5;
    _backView.layer.cornerRadius = _r1;
    _backView.backgroundColor = self.bubbleColor;
    [self.containerView addSubview:_backView];
    //需要注意添加顺序,ftontView在前添加会被backview挡住,导致看不到frontView
    [self.containerView addSubview:_frontView];
    
    //创建显示数字的label
    self.bubbleLabel = [[UILabel alloc]init];
    self.bubbleLabel.frame = CGRectMake(0, 0, _frontView.bounds.size.width, _frontView.bounds.size.height);
    self.bubbleLabel.textColor = [UIColor whiteColor];
    //文字位置:居中
    self.bubbleLabel.textAlignment = NSTextAlignmentCenter;
    [_frontView addSubview:self.bubbleLabel];
    
    //开始计算两个圆心的坐标
    _x1 = _backView.center.x;
    _y1 = _backView.center.y;
    _x2 = _frontView.center.x;
    _y2 = _frontView.center.y;
    
    //给frontView添加拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragGestureRecognizer:)];
    [_frontView addGestureRecognizer:pan];

}

- (void)dragGestureRecognizer:(UIPanGestureRecognizer *)pan {
    //计算当前手指的位置
    CGPoint fingerPoint = [pan locationInView:self.containerView];
    //判断当前状态
    if (pan.state == UIGestureRecognizerStateBegan) {
        _backView.hidden = NO;
        _fillCuteColor = self.bubbleColor;
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        _frontView.center = fingerPoint;
        
        if (_r1 <= 6) {
            _fillCuteColor = [UIColor clearColor];
            _backView.hidden = YES;
        }
        //开始重绘
        [self drawRect];
    }
}

- (void)drawRect {
    
}
@end
