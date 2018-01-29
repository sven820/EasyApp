//
//  UIColor+Extension.h
//  YXY
//
//  Created by wwq on 16/7/25.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
/**
 *  十六进制的颜色转换为UIColor
 *
 *  @param colorString 如：#cccccc
 *
 *  @return
 */
+ (UIColor *) colorWithHexString: (NSString *)colorString;

@end
