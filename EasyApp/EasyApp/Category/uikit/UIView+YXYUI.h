//
//  UIView+YXYUI.h
//  YXY
//
//  Created by jinxiaofei on 16/9/19.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YXYUI)

+ (instancetype)createLine;//light gray
+ (instancetype)createLineWithColor:(UIColor *)color;

//自定义圆角
- (void)cornerRadius:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
//三角形
+ (UIView *)threeAngleView:(CGRect)rect;
//房间定制
+ (UIView *)roomTopRoundView:(CGRect)rect;

//YXYView
+ (UISwitch *)yxySwitchView;
@end
