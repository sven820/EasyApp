//
//  UILabel+YXYLabel.h
//  YXY
//
//  Created by jinxiaofei on 16/12/29.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (YXYLabel)
+ (instancetype) createLabelWithFont:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment bg:(UIColor *)bgColor text:(NSString *)text;
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;
@end
