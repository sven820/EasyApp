//
//  NSData+ZIP.h
//  YXY
//
//  Created by wwq on 16/8/4.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ZIP)
/**
 *  解压缩
 *
 *  @return
 */
- (NSData *) deCompress;
/**
 *  压缩
 *
 *  @return
 */
- (NSData *) compress;
@end
