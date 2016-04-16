//
//  ViewController.m
//  QQMessageCountDemo
//
//  Created by James on 16/4/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "LJCuteView.h"

@interface ViewController ()

@end

@implementation ViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LJCuteView  *cv = [[LJCuteView alloc]initWithPoint:CGPointMake(20, self.view.bounds.size.height - 50) superView:self.view];
    
    cv.bubbleWidth = 35;
    cv.bubbleColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
    [cv setUp];
    cv.viscosity = 20;
    
    cv.bubbleLabel.text = @"999";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
