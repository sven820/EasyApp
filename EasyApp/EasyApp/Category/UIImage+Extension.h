//
//  UIImage+Extension.h
//  YXY
//
//  Created by wwq on 16/8/31.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)getBlurImage:(UIImage *)image;
#pragma mark - 颜色图片
+ (UIImage *) imageWithColor:(UIColor *)color;
+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - 矩形图片
+ (UIImage *)rectImageWithSize:(CGSize)size image:(UIImage *)image;
#pragma mark - 圆角图片
+ (UIImage *)cornerWithRadius:(CGFloat)radius image:(UIImage *)image;
+ (UIImage *)cornerWithCorners:(UIRectCorner)corners radius:(CGFloat)radius image:(UIImage *)image;
#pragma mark - 圆形图片
+ (UIImage *) roundImageWithName:(NSString *)imageName;
+ (UIImage *) roundImageWithImage:(UIImage *)image;

+ (UIImage *) roundImageWithName:(NSString *)imageName edgeWidth:(CGFloat)edgeWidth edgeColor:(UIColor *)edgeColor;
+ (UIImage *) roundImageWithImage:(UIImage *)image edgeWidth:(CGFloat)edgeWidth edgeColor:(UIColor *)edgeColor;

+ (UIImage *) roundImageWithName:(NSString *)imageName size:(CGSize)size;
+ (UIImage *) roundImageWithImage:(UIImage *)image size:(CGSize)size;

+ (UIImage *) roundImageWithName:(NSString *)imageName size:(CGSize)size edgeWidth:(CGFloat)edgeWidth edgeColor:(UIColor *)edgeColor;
+ (UIImage *) roundImageWithImage:(UIImage *)image size:(CGSize)size edgeWidth:(CGFloat)edgeWidth edgeColor:(UIColor *)edgeColor;


#pragma mark - 压缩图片
+ (NSData *)compressImageBackData:(UIImage *)image
                    compressRatio:(CGFloat)ratio
                 maxCompressRatio:(CGFloat)maxRatio
                    maxUploadSize:(NSInteger)maxUploadSize;
#pragma mark - other
/** 传入图片名称,返回拉伸好的图片*/
+ (UIImage *)resizeImage:(NSString *)imageName;
- (UIImage *)resizeImage;
- (UIImage *)resizeImageX:(CGFloat)x y:(CGFloat)y;
/** 获得某个像素的颜色*/
- (UIColor *)pixelColorAtLocation:(CGPoint)point;
/** 取消系统渲染*/
+ (UIImage *)imageWithOriginalRender:(NSString *)imageName;
/** 文字图片*/
+ (UIImage *)imageWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color bgColor:(UIColor *)bgColor size:(CGSize)size;
+ (UIImage *)imageFromText:(NSArray*)arrContent withFont:(UIFont *)font color:(UIColor *)color maxWidth:(CGFloat)maxWidth;

- (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithCusView:(UIView *)view;
@end
