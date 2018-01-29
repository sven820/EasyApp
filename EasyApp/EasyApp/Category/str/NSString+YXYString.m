//
//  NSString+YXYString.m
//  YXY
//
//  Created by jinxiaofei on 16/11/13.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "NSString+YXYString.h"

@implementation NSString (YXYString)
- (BOOL)checkIsEmpty
{
    BOOL isEmpty = YES;
    if ([self isKindOfClass:[NSString class]] && self.length) {
        isEmpty = NO;
    }
    return isEmpty;
}
//处理手机号,身份证等中间带*
- (NSString *)showStarMiddle:(NSInteger)sideShowCount;
{
    if (self.length <= sideShowCount * 2) {
        return self;
    }
    NSMutableString *replaceStr = [NSMutableString string];
    for (int i = 0; i < self.length - sideShowCount * 2; i++) {
        [replaceStr appendString:@"*"];
    }
    NSString *str = [self stringByReplacingCharactersInRange:NSMakeRange(sideShowCount, self.length - sideShowCount * 2) withString:replaceStr];
    
    return str;
}

// 检查是否是 http:// URL
+ (BOOL)checkIsHTTPURL:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    if (url != nil && ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]))
    {
        return YES;
    }
    return NO;
}

+ (NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

+ (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

+ (BOOL)checkIsPhoneNumber:(NSString *)phone
{
    NSString *regex = @"^[1][358][0-9]{9}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [numberPre evaluateWithObject:phone];
}

+ (BOOL)checkIsEmail:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

+ (BOOL)checkIsIdentityCard:(NSString *)IDCardNumber
{
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}

- (CGSize)boundingSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary*attrs =@{NSFontAttributeName: font};
    return  [self  boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs   context:nil].size;
}

+(NSString *)stripString:(NSString *)str length:(NSInteger)len
{
    if(str){
        if(str.length <= len){
            return str;
        }else{
            return [[str substringWithRange:NSMakeRange(0, len)] stringByAppendingString:@"..."];
        }
    }
    return @"";
}
@end
