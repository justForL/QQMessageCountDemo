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
    
    //记录原始backView的位置信息
    CGRect    _oldBackFrame;
    CGPoint   _oldBackPoint;
    
    UIBezierPath   *_cutePath;
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
    
    //用于结束拖拽手势时,将frontView恢复初始位置
    _oldBackFrame = _backView.frame;
    _oldBackPoint = _backView.center;
    
    _backView.hidden = YES;
    [self addAnimationLikeGameCenter];
    
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
        //移除GameCenter动画特效
        [self removeAnimationLickGameCenter];
        
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        _frontView.center = fingerPoint;
        
        if (_r1 <= 6) {
            _fillCuteColor = [UIColor clearColor];
            _backView.hidden = YES;
            [_shapeLayer removeFromSuperlayer];
        }
        //开始重绘
        [self drawRect];
    }else if (pan.state == UIGestureRecognizerStateEnded || pan.state ==UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed) {
        //当取消 拖拽结束  失败状态下 需要做的操作
        _backView.hidden = YES;
        _fillCuteColor = [UIColor clearColor];
        
        [_shapeLayer removeFromSuperlayer];
        
        //frontView恢复初始状态时的动画效果
        [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _frontView.center = _oldBackPoint;
        } completion:^(BOOL finished) {
            
            [self addAnimationLikeGameCenter];
        }];
        
    }
}

- (void)drawRect {
    //开始计算两个圆心的坐标
    _x1 = _backView.center.x;
    _y1 = _backView.center.y;
    _x2 = _frontView.center.x;
    _y2 = _frontView.center.y;
    
    _centerDistance = sqrtf((_x2 - _x1) *(_x2 - _x1) + (_y2 - _y1) * (_y2 - _y1));
    
    //不加判断,并不会导致0做除数而crash,因为 这个方法是在进行拖拽的时候出发,一旦触发,centerDistance永远不会为0
    if (_centerDistance == 0) {
        _sinDigree = 0;
        _cosDigree = 1;
    }else {
        _sinDigree = (_x2 - _x1) / _centerDistance;
        _cosDigree = (_y2 - _y1) / _centerDistance;
    }
    //在拖拽的时候,让backView的半径发生改变 
    _r1 = _oldBackFrame.size.width / 2 - _centerDistance / self.viscosity;
    
    _pointA = CGPointMake(_x1 - _r1 * _cosDigree, _y1 + _r1 * _sinDigree);
    _pointB = CGPointMake(_x1 + _r1 * _cosDigree, _y1 - _r1 * _sinDigree);
    _pointD = CGPointMake(_x2 - _R2 * _cosDigree, _y2 + _R2 * _sinDigree);
    _pointC = CGPointMake(_x2 + _R2 * _cosDigree, _y2 - _R2 * _sinDigree);
    
    
    _pointO = CGPointMake(_pointA.x + (_centerDistance / 2)*_sinDigree, _pointA.y + (_centerDistance / 2)*_cosDigree);
    _pointP = CGPointMake(_pointB.x + (_centerDistance / 2)*_sinDigree, _pointB.y + (_centerDistance / 2)*_cosDigree);
    
    _backView.center = _oldBackPoint;
    _backView.bounds = CGRectMake(0, 0, _r1 * 2, _r1 * 2);
    
    _backView.layer.cornerRadius = _r1;
    
    _cutePath = [UIBezierPath bezierPath];
    [_cutePath moveToPoint:_pointA];
    [_cutePath addQuadCurveToPoint:_pointD controlPoint:_pointO];
    [_cutePath addLineToPoint:_pointC];
    [_cutePath addQuadCurveToPoint:_pointB controlPoint:_pointP];
    [_cutePath moveToPoint:_pointA];
    
    if (_backView.hidden == NO) {
        _shapeLayer.path = [_cutePath CGPath];
        _shapeLayer.fillColor = [_fillCuteColor CGColor];
        //如果使用addSubLayer  会导致重绘的图形盖住_fontView的数字
        [self.containerView.layer insertSublayer:_shapeLayer below:_frontView.layer];
    }
    
}
/**
 *  类似gamecenter的动画特效
 */
- (void)addAnimationLikeGameCenter {
    //关键帧动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    /*
     kCAFillModeRemoved 这个是默认值，也就是说当动画开始前和动画结束后，动画对layer都没有影响，动画结束后，layer会恢复到之前的状态
     
     kCAFillModeForwards 当动画结束后，layer会一直保持着动画最后的状态
     
     kCAFillModeBackwards 在动画开始前，只需要将动画加入了一个layer，layer便立即进入动画的初始状态并等待动画开始。
     
     kCAFillModeBoth 这个其实就是上面两个的合成.动画加入后开始之前，layer便处于动画初始状态，动画结束后layer保持动画最后的状态

     */
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 5.0;
    
    CGMutablePathRef curvesPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(_frontView.frame, _frontView.bounds.size
                                         .width /2 - 3, _frontView.bounds.size.width / 2 - 3);
    
    CGPathAddEllipseInRect(curvesPath, NULL, circleContainer);
    
    pathAnimation.path = curvesPath;
    
    CGPathRelease(curvesPath);
    //做圆形轨迹移动
    [_frontView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
    
}
/**
 *  移除所有动画特效
 */
- (void)removeAnimationLickGameCenter {
    [_frontView.layer removeAllAnimations];
}
@end
