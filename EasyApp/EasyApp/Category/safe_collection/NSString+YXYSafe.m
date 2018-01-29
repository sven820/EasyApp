//
//  NSString+YCFSafe.m
//  YCFComponentKit_OC
//
//  Created by JJ.sven on 16/8/9.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "NSString+YXYSafe.h"

@implementation NSString (YXYSafe)
+ (BOOL)checkIsEmptyOrNull:(NSString *)string
{
    if (string && ![string isEqual:[NSNull null]] && ![string isEqual:@"(null)"] && ![string isEqualToString:@"<null>"] && [string length] > 0)
    {
        return NO;
    }
    return YES;
}

+ (NSRange)safe_rangeOfString:(NSString *)searchString inSourceString:(NSString *)source
{
#ifdef OpenSafeCollection
    if ([NSString checkIsEmptyOrNull:source] || [NSString checkIsEmptyOrNull:searchString])
    {
        return NSMakeRange(NSNotFound, 0);
    }
    else
    {
        NSRange range = [source rangeOfString:searchString];
        return range;
    }
#else
    return [source rangeOfString:searchString];
#endif
}

+ (NSRange)safe_rangeOfCharacterFromSet:(NSCharacterSet *)searchSet inSourceString:(NSString *)source
{
#ifdef OpenSafeCollection
    if (searchSet == nil || [NSString checkIsEmptyOrNull:source])
    {
        return NSMakeRange(NSNotFound, 0);
    }
    else
    {
        NSRange range = [source rangeOfCharacterFromSet:searchSet];
        return range;
    }
#else
    return [source rangeOfCharacterFromSet:searchSet];
#endif
}

+ (NSString *)safe_string:(NSString *)aString
{
#ifdef OpenSafeCollection
    if ([NSString checkIsEmptyOrNull:aString])
    {
        return @"";
    }
    else
    {
        return aString;
    }
#else
    return aString;
#endif
}

- (NSString *)safe_stringByAppendingString:(NSString *)aString
{
#ifdef OpenSafeCollection
    if ([NSString checkIsEmptyOrNull:aString])
    {
        return self;
    }
    else
    {
        return [self stringByAppendingString:aString];
    }
#else
    return [self stringByAppendingString:aString];
#endif
}

@end
