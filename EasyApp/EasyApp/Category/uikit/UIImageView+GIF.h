//
//  UIImageView+GIF.h
//  YXY
//
//  Created by wwq on 16/7/7.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//gif 播放完后显示gif的哪张图
typedef NS_ENUM(NSUInteger, UIImageViewGifFillMode) {
    UIImageViewGifFillModeFirst,//显示第一张
    UIImageViewGifFillModeLast,//显示最后一张
    UIImageViewGifFillModeNone,//不显示
};

@interface UIImageView (GIF)
- (void) setGifImageWithURL:(NSURL *) url;
- (void) setGifImageWithURL:(NSURL *) url placeholder:(UIImage *) placeholder;

- (CAKeyframeAnimation *)playGifImageWithRepeatCount:(NSInteger)repeatCount
                                            duration:(float)duration //=0，则使用gif的默认时间
                                           imageData:(NSData *)gifData
                                            fillMode:(UIImageViewGifFillMode)fillMode
                                               delay:(float)delay;
@end
