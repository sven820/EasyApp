//
//  UILabel+YXYLabel.m
//  YXY
//
//  Created by jinxiaofei on 16/12/29.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "UILabel+YXYLabel.h"

@implementation UILabel (YXYLabel)
+ (instancetype) createLabelWithFont:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment bg:(UIColor *)bgColor text:(NSString *)text
{
    return [[self alloc]initWithFont:font color:color alignment:alignment bg:bgColor text:text];
}

- (instancetype)initWithFont:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment bg:(UIColor *)bgColor text:(NSString *)text
{
    if (self = [super initWithFrame:CGRectZero]) {
        if (font) {
            self.font = font;
        }
        if (color) {
            self.textColor = color;
        }
        if (bgColor) {
            self.backgroundColor = bgColor;
        }
        if (text) {
            self.text = text;
        }
        self.textAlignment = alignment;
    }
    return self;
}

+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

@end
