//
//  NSString+YXYString.h
//  YXY
//
//  Created by jinxiaofei on 16/11/13.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (YXYString)
- (BOOL)checkIsEmpty;
//处理手机号,身份证等中间带*
- (NSString *)showStarMiddle:(NSInteger)sideShowCount;
// 检查是否是 http:// URL
+ (BOOL)checkIsHTTPURL:(NSString *)string;

+(NSString *)URLEncodedString:(NSString *)str;
+(NSString *)URLDecodedString:(NSString *)str;

// 校验是否是手机号,只校验11位数字
+ (BOOL)checkIsPhoneNumber:(NSString *)phone;
// 校验是否是邮箱
+ (BOOL)checkIsEmail:(NSString *)string;
// 校验是否是身份证
+ (BOOL)checkIsIdentityCard:(NSString *)IDCardNumber;

- (CGSize)boundingSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSString *)stripString:(NSString *)str length:(NSInteger)len;
@end
