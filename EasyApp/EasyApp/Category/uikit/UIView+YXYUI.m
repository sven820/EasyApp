//
//  UIView+YXYUI.m
//  YXY
//
//  Created by jinxiaofei on 16/9/19.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "UIView+YXYUI.h"

@implementation UIView (YXYUI)

+ (instancetype)createLine
{
    UIColor *baseLineColor = [UIColor lightGrayColor];
    UIView *line = [self createLineWithColor:baseLineColor];
    return line;
}
+ (instancetype)createLineWithColor:(UIColor *)color
{
    UIView *line = [UIView new];
    line.backgroundColor = color;
    return line;
}

- (void)cornerRadius:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
+ (UIView *)threeAngleView:(CGRect)rect
{
    UIView *view = [UIView new];
    view.bounds = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(rect.size.width * 0.5, 0)];
    [maskPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [maskPath addLineToPoint:CGPointMake(0, rect.size.height)];
    [maskPath addLineToPoint:CGPointMake(rect.size.width * 0.5, 0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    return view;
}
+ (UIView *)roomTopRoundView:(CGRect)rect
{
    UIView *view = [UIView new];
    view.bounds = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(0, rect.size.width * 0.5)];
    [maskPath addLineToPoint:CGPointMake(0, rect.size.height)];
    [maskPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [maskPath addLineToPoint:CGPointMake(rect.size.width, rect.size.width * 0.5)];
    [maskPath addArcWithCenter:CGPointMake(rect.size.width * 0.5, rect.size.width * 0.5) radius:rect.size.width * 0.5 startAngle:0 endAngle:M_PI clockwise:NO];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    return view;
}
//YXYView
+ (UISwitch *)yxySwitchView
{
    UISwitch *switchView = [[UISwitch alloc]init];
    switchView = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 36, 16)];
//    switchView.onTintColor = [UIColor colorWithCode:YXY_COLOR_C1];
//    switchView.tintColor = [UIColor colorWithCode:YXY_COLOR_C4];
//    switchView.backgroundColor = [UIColor colorWithCode:YXY_COLOR_C4];
    switchView.layer.cornerRadius = switchView.bounds.size.height / 2;
    switchView.clipsToBounds = YES;
    return switchView;
}
@end
