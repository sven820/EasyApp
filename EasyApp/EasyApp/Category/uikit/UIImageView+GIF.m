//
//  UIImageView+GIF.m
//  YXY
//
//  Created by wwq on 16/7/7.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "UIImageView+GIF.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>
#import <ImageIO/ImageIO.h>

@implementation UIImageView (GIF)
- (void) setGifImageWithURL:(NSURL *) url
{
    [self setGifImageWithURL:url placeholder:nil];
}

- (void) setGifImageWithURL:(NSURL *) url placeholder:(UIImage *) placeholder
{
    self.image = placeholder;
    
    [self sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        self.image = [image sd_animatedImageByScalingAndCroppingToSize:image.size];
    }];
}
- (CAKeyframeAnimation *)playGifImageWithRepeatCount:(NSInteger)repeatCount duration:(float)duration imageData:(NSData *)gifData fillMode:(UIImageViewGifFillMode)fillMode delay:(float)delay
{
    //2.获取gif文件数据
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)gifData, NULL);
    //3.获取gif文件中图片的个数
    size_t count = CGImageSourceGetCount(source);
    //4.定义一个变量记录gif播放一轮的时间
    float allTime = 0;
    //5.定义一个可变数组存放所有图片
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    //6.定义一个可变数组存放每一帧播放的时间
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    //7.每张图片的宽度
    NSMutableArray *widthArray = [[NSMutableArray alloc] init];
    //8.每张图片的高度
    NSMutableArray *heightArray = [[NSMutableArray alloc] init];
    
    //遍历gif
    for (size_t i=0; i<count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        [imageArray addObject:(__bridge UIImage *)(image)];
        CGImageRelease(image);
        
        //获取图片信息
        NSDictionary *info = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        NSLog(@"info---%@",info);
        //获取宽度
        CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
        //获取高度
        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
        
        //
        [widthArray addObject:[NSNumber numberWithFloat:width]];
        [heightArray addObject:[NSNumber numberWithFloat:height]];
        
        //统计时间
        NSDictionary *timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime] floatValue];
        [timeArray addObject:[NSNumber numberWithFloat:time]];
        allTime += time;
    }
    if (imageArray.count) {
        //添加帧动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        NSMutableArray *times = [[NSMutableArray alloc] init];
        float currentTime = 0;
        //设置每一帧的时间占比
        for (int i=0; i<imageArray.count; i++) {
            currentTime +=[timeArray[i] floatValue];
            float rate = currentTime/allTime;
            [times addObject:[NSNumber numberWithFloat:rate]];
        }
        [animation setKeyTimes:times];
        [animation setValues:imageArray];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        //设置循环
        animation.repeatCount = repeatCount;
        //设置播放总时长
        animation.duration = duration?duration:allTime;
        //
        animation.fillMode = kCAFillModeBoth;
        if (fillMode == UIImageViewGifFillModeFirst) {
            self.image = [UIImage imageWithCGImage:(CGImageRef)imageArray.firstObject scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        }else if(fillMode == UIImageViewGifFillModeLast){
            self.image = [UIImage imageWithCGImage:(CGImageRef)imageArray.lastObject scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        }

        //Layer层添加
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.layer addAnimation:animation forKey:@"gifAnimation"];
        });
        
        return animation;
    }else{
        self.image = [UIImage imageWithData:gifData];
    }
    
    return nil;
}

@end
