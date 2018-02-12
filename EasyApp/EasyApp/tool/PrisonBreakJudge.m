//
//  PrisonBreakJudge.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/2/9.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "PrisonBreakJudge.h"

@implementation PrisonBreakJudge
#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])

//这个表可以尽可能的列出来，然后判定是否存在，只要有存在的就可以认为机器是越狱了
const char* jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
};

- (BOOL)isJailBreak_1
{
    for (int i=0; i<ARRAY_SIZE(jailbreak_tool_pathes); i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
            NSLog(@"The device is jail broken!");
            return YES;
        }
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}
//URL scheme是可以用来在应用中呼出另一个应用，是一个资源的路径（详见《iOS中如何呼出另一个应用》），这个方法也就是在判定是否存在cydia这个应用。
- (BOOL)isJailBreak_2
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        NSLog(@"The device is jail broken!");
        return YES;
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}
//这个是利用不越狱的机器没有这个权限来判定的。
#define USER_APP_PATH                 @"/User/Applications/"
- (BOOL)isJailBreak_3
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:USER_APP_PATH]) {
        NSLog(@"The device is jail broken!");
        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:USER_APP_PATH error:nil];
        NSLog(@"applist = %@", applist);
        return YES;
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}
@end
