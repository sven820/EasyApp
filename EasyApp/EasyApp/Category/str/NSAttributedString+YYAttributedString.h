//
//  NSAttributedString+YYAttributedString.h
//  YXY
//
//  Created by jinxiaofei on 16/12/7.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LinkType)
{
    LinkTypeURL             = 1 << 0,
    LinkTypeTag             = 1 << 1,
    LinkTypeTopic           = 1 << 2,
    LinkTypeAt              = 1 << 3,
    LinkTypeEmail           = 1 << 4,
    LinkTypePhoneNum        = 1 << 5,//手机，座机等电话
    LinkTypeCellPhoneNum    = 1 << 6,//手机
    LinkTypeNum             = 1 << 7,
};

#define kWBLinkHrefName @"href" //NSString
#define kWBLinkURLName @"url" //WBURL
#define kWBLinkTagName @"tag" //WBTag
#define kWBLinkTopicName @"topic" //WBTopic
#define kWBLinkAtName @"at" //NSString
#define kWBLinkEmailName @"email" //NSString
#define kWBLinkPhoneName @"phone" //NSString

@interface NSAttributedString (YYAttributedString)

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font color:(UIColor *)color;
- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font color:(UIColor *)color lineSpace:(CGFloat)lineSpace;

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color;
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color lineSpace:(CGFloat)lineSpace;

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color paragraphHandle:(void(^)(NSMutableParagraphStyle *style))paragraphHandle;
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string attrHandle:(void(^)(NSMutableDictionary *attr, NSMutableParagraphStyle *style))attrHandle;



+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string
                                                     font:(UIFont *)font
                                                    color:(UIColor *)color
                                               hlightKeys:(NSArray<NSString *> *)keys
                                               hlightFont:(UIFont *)hlightFont
                                              hlightColor:(UIColor *)hlightColor
                                                lineSpace:(CGFloat)lineSpace;
+ (NSMutableAttributedString *)attributedStringWithAttrString:(NSAttributedString *)string
                                                   hlightKeys:(NSArray<NSString *> *)keys
                                                   hlightFont:(UIFont *)hlightFont
                                                  hlightColor:(UIColor *)hlightColor;

//高亮显示网址 电话
#warning LinkTypeNum有问题
+ (NSMutableAttributedString *)hlightAttributeString:(NSAttributedString *)string type:(LinkType)type font:(UIFont *)font color:(UIColor *)color;

- (CGRect)boundingRectMaxSize:(CGSize)maxSize;
@end
