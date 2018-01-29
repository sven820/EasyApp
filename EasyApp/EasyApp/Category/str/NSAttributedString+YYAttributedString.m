//
//  NSAttributedString+YYAttributedString.m
//  YXY
//
//  Created by jinxiaofei on 16/12/7.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "NSAttributedString+YYAttributedString.h"
#import <YYText.h>

@implementation NSAttributedString (YYAttributedString)
- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font color:(UIColor *)color
{
    return [self attributedStringWithFont:font color:color lineSpace:0];
}

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font color:(UIColor *)color lineSpace:(CGFloat)lineSpace
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithAttributedString:self];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:font forKey:NSFontAttributeName];
    [dict setObject:color forKey:NSForegroundColorAttributeName];
    if (lineSpace) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = lineSpace;// 字体的行间距
        [dict setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    [attr setAttributes:dict range:NSMakeRange(0, attr.length)];
    return attr;
}

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color
{
    return [self attributedStringWithString:string font:font color:color lineSpace:0];
}

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color lineSpace:(CGFloat)lineSpace
{
    if (!string) {
        return nil;
    }
    NSMutableDictionary *strAttr = [NSMutableDictionary dictionary];
    if (lineSpace) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = lineSpace;// 字体的行间距
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [strAttr setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    [strAttr setObject:font forKey:NSFontAttributeName];
    [strAttr setObject:color forKey:NSForegroundColorAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:string attributes:strAttr];
    return attributedString;
}
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color paragraphHandle:(void(^)(NSMutableParagraphStyle *style))paragraphHandle
{
    NSMutableDictionary *strAttr = [NSMutableDictionary dictionary];
    if (paragraphHandle) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphHandle(paragraphStyle);
        [strAttr setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    [strAttr setObject:font forKey:NSFontAttributeName];
    [strAttr setObject:color forKey:NSForegroundColorAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:string attributes:strAttr];
    return attributedString;
}
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string attrHandle:(void(^)(NSMutableDictionary *attr, NSMutableParagraphStyle *style))attrHandle
{
    NSMutableDictionary *strAttr = [NSMutableDictionary dictionary];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (attrHandle) {
        attrHandle(strAttr, paragraphStyle);
    }
    [strAttr setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:string attributes:strAttr];
    return attributedString;
}
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string
                                                     font:(UIFont *)font
                                                    color:(UIColor *)color
                                               hlightKeys:(NSArray<NSString *> *)keys
                                               hlightFont:(UIFont *)hlightFont
                                              hlightColor:(UIColor *)hlightColor
                                                lineSpace:(CGFloat)lineSpace
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{NSFontAttributeName : font,NSForegroundColorAttributeName : color}];
    if (lineSpace) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = lineSpace;// 字体的行间距
        [dic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:string attributes:dic];
    for (NSString *key in keys)
    {
        NSError *error = nil;
        NSString *regexStr = key;
        
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexStr
                                                                               options:0
                                                                                 error:&error];
        
        NSArray *array = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        for (NSTextCheckingResult *result in array) {
            NSRange r = result.range;
            NSDictionary *sAtr = @{NSFontAttributeName : hlightFont,NSForegroundColorAttributeName : hlightColor};
            if (r.length) {
                [attrStr setAttributes:sAtr range:r];
            }
        }
        
    }
    
    return attrStr;
}
+ (NSMutableAttributedString *)attributedStringWithAttrString:(NSAttributedString *)string
                                                   hlightKeys:(NSArray<NSString *> *)keys
                                                   hlightFont:(UIFont *)hlightFont
                                                  hlightColor:(UIColor *)hlightColor
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:string];
    NSString *nsString = string.string;
    for (NSString *key in keys) {
        NSError *error = nil;
        NSString *regexStr = key;
        
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexStr
                                                                               options:0
                                                                                 error:&error];
        
        NSArray *array = [regex matchesInString:nsString options:0 range:NSMakeRange(0, nsString.length)];
        for (NSTextCheckingResult *result in array) {
            NSRange r = result.range;
            NSDictionary *sAtr = @{NSFontAttributeName : hlightFont,NSForegroundColorAttributeName : hlightColor};
            if (r.length) {
                [attrStr setAttributes:sAtr range:r];
            }
        }
    }
    return attrStr;
}

- (CGRect)boundingRectMaxSize:(CGSize)maxSize
{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
}

+ (NSMutableAttributedString *)hlightAttributeString:(NSAttributedString *)string type:(LinkType)type font:(UIFont *)font color:(UIColor *)color
{
    if (!font) {
        font = [UIFont systemFontOfSize:14];
    }
    if (!color) {
        color = [UIColor blackColor];
    }
    
    YYTextBorder *highlightBorder = [YYTextBorder new];
    //    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    //    highlightBorder.cornerRadius = 3;
    //    highlightBorder.fillColor = [UIColor greenColor];

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:string];
    
    if ((type & LinkTypePhoneNum) == LinkTypePhoneNum) {
        NSArray *resultPhone = [[self regexPhone] matchesInString:attrString.string options:kNilOptions range:attrString.yy_rangeOfAll];
        for (NSTextCheckingResult *at in resultPhone)
        {
            if (at.range.location == NSNotFound && at.range.length <= 1)
            {
                continue;
            }
            if ([attrString yy_attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil)
            {
                [attrString yy_setColor:color range:at.range];
                [attrString yy_setFont:font range:at.range];
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kWBLinkPhoneName : [attrString.string substringWithRange:NSMakeRange(at.range.location, at.range.length)],@"type":@(LinkTypePhoneNum)};
                [attrString yy_setTextHighlight:highlight range:at.range];
            }
        }
    }

    if ((type & LinkTypeCellPhoneNum) == LinkTypeCellPhoneNum) {
        NSArray *resultPhone = [[self regexCellPhone] matchesInString:attrString.string options:kNilOptions range:attrString.yy_rangeOfAll];
        for (NSTextCheckingResult *at in resultPhone)
        {
            if (at.range.location == NSNotFound && at.range.length <= 1)
            {
                continue;
            }
            if ([attrString yy_attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil)
            {
                [attrString yy_setColor:color range:at.range];
                [attrString yy_setFont:font range:at.range];
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kWBLinkPhoneName : [attrString.string substringWithRange:NSMakeRange(at.range.location, at.range.length)],@"type":@(LinkTypePhoneNum)};
                [attrString yy_setTextHighlight:highlight range:at.range];
            }
        }
    }
    if ((type & LinkTypeURL) == LinkTypeURL) {
        NSArray *resultUrl = [[self regexUrl] matchesInString:attrString.string options:kNilOptions range:attrString.yy_rangeOfAll];
        for (NSTextCheckingResult *at in resultUrl)
        {
            if (at.range.location == NSNotFound && at.range.length <= 1)
            {
                continue;
            }
            
            if ([attrString yy_attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil)
            {
                [attrString yy_setColor:color range:at.range];
                [attrString yy_setFont:font range:at.range];
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kWBLinkURLName : [attrString.string substringWithRange:NSMakeRange(at.range.location, at.range.length)],@"type":@(LinkTypeURL)};
                [attrString yy_setTextHighlight:highlight range:at.range];
            }
        }
    }
    if ((type & LinkTypeNum) == LinkTypeNum) {
        NSArray *resultNum = [[self regexNumber] matchesInString:attrString.string options:kNilOptions range:attrString.yy_rangeOfAll];
        for (NSTextCheckingResult *at in resultNum)
        {
            if (at.range.location == NSNotFound && at.range.length <= 1)
            {
                continue;
            }
            
            if ([attrString yy_attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil)
            {
                [attrString yy_setColor:color range:at.range];
                [attrString yy_setFont:font range:at.range];
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kWBLinkPhoneName : [attrString.string substringWithRange:NSMakeRange(at.range.location, at.range.length)],@"type":@(LinkTypePhoneNum)};
                [attrString yy_setTextHighlight:highlight range:at.range];
            }
        }
    }
    return attrString;
}

+ (NSRegularExpression *)regexUrl
{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexPhone
{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)" options:kNilOptions error:NULL];
    });
    return regex;
}
+ (NSRegularExpression *)regexCellPhone
{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexNumber
{
    
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:
                 @"(-?\\d*)(\\.\\d+)?" options:kNilOptions error:NULL];
    });
    return regex;
}

@end
