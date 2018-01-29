//
//  NSDate+YXYDate.m
//  YXY
//
//  Created by jinxiaofei on 16/9/27.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "NSDate+YXYDate.h"
#import <NSDate+DateTools.h>

@implementation NSDate (YXYDate)

//TimeInterval 1970
+ (NSString *)stringDateWithTimeInterval:(NSTimeInterval)timeInterval type:(YXYDateFormatterType)type
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self stringWithFormat:[self getFormatString:type] date:date];
}

+ (NSString *)stringWithFormat:(NSString *)format date:(NSDate *)date
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:date];
    
    return timestamp_str;
}
+ (NSString *)msgTimeStringDateWithTimeInterval:(NSTimeInterval)timeInterval todayType:(YXYDateFormatterType)type boforeToday:(YXYDateFormatterType)bType
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    if ([date isToday]) {
        return [self stringDateWithTimeInterval:timeInterval type:type];
    }else{
        return [self stringDateWithTimeInterval:timeInterval type:bType];
    }
}
- (NSTimeInterval)compareMinutesLaterThan:(NSDate *)date
{
    NSTimeInterval m = [self minutesLaterThan:date];
    return m;
}
+ (NSString *)formatStringDate:(NSString *)dateStr strFormatType:(YXYDateFormatterType)type toType:(YXYDateFormatterType)toType
{
    NSDate *date = [NSDate dateWithString:dateStr formatString:[self getFormatString:type]];
    return [self stringWithFormat:[self getFormatString:toType] date:date];
}
+ (NSDate *)dateWithStringDate:(NSString *)date type:(YXYDateFormatterType)type
{
    return [NSDate dateWithString:date formatString:[self getFormatString:type]];
}

//
- (BOOL)beforeDate:(NSDate *)date
{
    return [self isEarlierThan:date];
}
- (BOOL)isAfterDate:(NSDate *)date
{
    return [self isLaterThan:date];
}
- (BOOL)isEqualDate:(NSDate *)date
{
    return [self isEqualToDate:date];
}
#pragma mark - private
+ (NSString *)getFormatString:(YXYDateFormatterType)formatType
{
    NSString *formatStr;
    switch (formatType) {
        case YXYDateFormatterTypeMMdd:
            formatStr = @"MM/dd";
            break;
        case YXYDateFormatterTypeYYMMDD:
            formatStr = @"yyyy/MM/dd";
            break;
        case YXYDateFormatterTypeHHMM:
            formatStr = @"HH:mm";
            break;
        case YXYDateFormatterTypeHHMMSS:
            formatStr = @"HH:mm:ss";
            break;
        case YXYDateFormatterTypeFull:
            formatStr = @"yyyy年MM月dd日 HH:mm:ss";
            break;
        case YXYDateFormatterTypeDefault:
            formatStr = @"MM月dd日 HH:mm";
            break;
        case YXYDateFormatterTypeDefaultMMdd:
            formatStr = @"MM月dd日";
            break;
        case YXYDateFormatterTypeService:
            formatStr = @"yyyy-MM-dd, HH:mm:ss";
            break;
        case YXYDateFormatterTypeService2:
            formatStr = @"yyyy-MM-dd HH:mm:ss";
            break;
        case YXYDateFormatterTypeLog:
            formatStr = @"yyyy-MM-dd";
            break;

    }
    return formatStr;
}

@end
