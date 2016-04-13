//
//  LJCuteView.h
//  QQMessageCountDemo
//
//  Created by James on 16/4/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJCuteView : UIView
/**
 *  气泡颜色
 */
@property (nonatomic, strong) UIColor *bubbleColor;
/**
 *  气泡数字
 */
@property (nonatomic, strong) UILabel *bubbleLabel;
/**
 *  气泡宽度
 */
@property (nonatomic, assign) CGFloat bubbleWidth;
/**
 *  气泡拉伸长度
 */
@property (nonatomic, assign) CGFloat viscosity;
/**
 *  父视图
 */
@property (nonatomic, strong) UIView *containerView;

/**
 *  指定位置信息
 *
 *  @param point     point
 *  @param superView superView
 *
 *  @return init
 */
- (instancetype)initWithPoint:(CGPoint)point superView:(UIView *)superView;


- (void)setUp;
@end
