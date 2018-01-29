//
//  NSDate+YXYDate.h
//  YXY
//
//  Created by jinxiaofei on 16/9/27.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YXYDateFormatterType) {
    YXYDateFormatterTypeMMdd,
    YXYDateFormatterTypeYYMMDD,
    YXYDateFormatterTypeHHMM,
    YXYDateFormatterTypeHHMMSS,
    YXYDateFormatterTypeFull,
    YXYDateFormatterTypeDefault,
    YXYDateFormatterTypeDefaultMMdd,
    YXYDateFormatterTypeService,// 2015-04-28, 10:58:04
    YXYDateFormatterTypeService2,// 2015-04-28 10:58:04
    YXYDateFormatterTypeLog,//20170804
};

@interface NSDate (YXYDate)
//TimeInterval 1970
+ (NSString *)stringDateWithTimeInterval:(NSTimeInterval)timeInterval type:(YXYDateFormatterType)type;

+ (NSString *)msgTimeStringDateWithTimeInterval:(NSTimeInterval)timeInterval todayType:(YXYDateFormatterType)type boforeToday:(YXYDateFormatterType)bType;

- (NSTimeInterval)compareMinutesLaterThan:(NSDate *)date;

+ (NSString *)formatStringDate:(NSString *)dateStr strFormatType:(YXYDateFormatterType)type toType:(YXYDateFormatterType)toType;
+ (NSDate *)dateWithStringDate:(NSString *)date type:(YXYDateFormatterType)type;

//时间顺序判断
- (BOOL)isBeforeDate:(NSDate *)date;
- (BOOL)isAfterDate:(NSDate *)date;
- (BOOL)isEqualDate:(NSDate *)date;
@end
