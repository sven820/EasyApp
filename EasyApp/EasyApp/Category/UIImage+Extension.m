//
//  UIImage+Extension.m
//  YXY
//
//  Created by wwq on 16/8/31.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (UIImage *)getBlurImage:(UIImage *)image
{
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    [filter setValue:[NSNumber numberWithFloat:50.0] forKey:@"inputRadius"];
    
    //        CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CIImage *result=[filter outputImage];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *rImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return rImage;
}

+ (UIImage *) imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (UIImage *)rectImageWithSize:(CGSize)size image:(UIImage *)image
{
    return [image p_rectImageWithSize:size];
}
+ (UIImage *)cornerWithRadius:(CGFloat)radius image:(UIImage *)image
{
    return [image p_cornerWithRadius:radius];
}
+ (UIImage *)cornerWithCorners:(UIRectCorner)corners radius:(CGFloat)radius image:(UIImage *)image
{
    return [image p_cornerWithCorners:corners radius:radius];
}
+ (UIImage *) roundImageWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [self roundImageWithImage:image];
}
+ (UIImage *)roundImageWithImage:(UIImage *)image
{
    UIImage *newImage = [image p_rounndImageWithSize:image.size];
    return newImage;
}
+ (UIImage *) roundImageWithName:(NSString *)imageName edgeWidth:(CGFloat)edgeWidth edgeColor:(UIColor *)edgeColor
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [self roundImageWithImage:image edgeWidth:edgeWidth edgeColor:edgeColor];
}
+ (UIImage *)roundImageWithImage:(UIImage *)image edgeWidth:(CGFloat)edgeWidth edgeColor:(UIColor *)edgeColor
{
    UIImage *newImage = [image p_roundImageWithSize:image.size edgeWidth:edgeWidth edgeColor:edgeColor];
    return newImage;
}

+ (UIImage *) roundImageWithName:(NSString *)imageName size:(CGSize)size
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [self roundImageWithImage:image size:size];
}
+ (UIImage *)roundImageWithImage:(UIImage *)image size:(CGSize)size
{
    UIImage *newImage = [image p_rounndImageWithSize:size];
    return newImage;
}
+ (UIImage *)roundImageWithName:(NSString *)imageName size:(CGSize)size edgeWidth:(CGFloat)edgeWidth edgeColor:(UIColor *)edgeColor
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [self roundImageWithImage:image size:size edgeWidth:edgeWidth edgeColor:edgeColor];
}
+ (UIImage *)roundImageWithImage:(UIImage *)image size:(CGSize)size edgeWidth:(CGFloat)edgeWidth edgeColor:(UIColor *)edgeColor
{
    UIImage *newImage = [image p_roundImageWithSize:size edgeWidth:edgeWidth edgeColor:edgeColor];
    return newImage;
}

/**
 *  传入图片名称,返回拉伸好的图片
 */
+ (UIImage *)resizeImage:(NSString *)imageName
{
    return [[UIImage imageNamed:imageName] resizeImage];
}

- (UIImage *)resizeImage
{
    CGFloat width = self.size.width * 0.5;
    CGFloat height = self.size.height * 0.5;
    return [self stretchableImageWithLeftCapWidth:width topCapHeight:height];
}
- (UIImage *)resizeImageX:(CGFloat)x y:(CGFloat)y
{
    CGFloat width = self.size.width * x;
    CGFloat height = self.size.height * y;
    return [self stretchableImageWithLeftCapWidth:width topCapHeight:height];
}
/**
 *  获得某个像素的颜色
 *
 *  @param point 像素点的位置
 */
- (UIColor *)pixelColorAtLocation:(CGPoint)point {
    UIColor *color = nil;
    CGImageRef inImage = self.CGImage;
    CGContextRef contexRef = [self p_ARGBBitmapContextFromImage:inImage];
    if (contexRef == NULL) return nil;
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(contexRef, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (contexRef);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        //		NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    // When finished, release the context
    CGContextRelease(contexRef);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}

+ (UIImage *)imageWithOriginalRender:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
+ (UIImage *)imageWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color bgColor:(UIColor *)bgColor size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGRect bgRect = CGRectMake(0, 0, size.width , size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bgRect];
    [path addClip];
    //计算文字所占的size,文字居中显示在画布上
    CGSize sizeText=[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}context:nil].size;
    //文字居中显示在画布上
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setObject:font forKey:NSFontAttributeName];
    [attr setObject:color forKey:NSForegroundColorAttributeName];
    [attr setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    if (bgColor)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [bgColor CGColor]);
        CGContextFillRect(context, bgRect);
    }

    CGRect rect = CGRectMake((size.width-sizeText.width)/2, (size.height-sizeText.height)/2, sizeText.width, sizeText.height);
    [text drawInRect:rect withAttributes:attr];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - 图片压缩
+ (NSData *)compressImageBackData:(UIImage *)image compressRatio:(CGFloat)ratio maxCompressRatio:(CGFloat)maxRatio maxUploadSize:(NSInteger)maxUploadSize
{
    //We define the max and min resolutions to shrink to
    //    int MIN_UPLOAD_RESOLUTION = [[UIScreen mainScreen]bounds].size.width * [[UIScreen mainScreen]bounds].size.height;
    NSInteger MAX_UPLOAD_SIZE = maxUploadSize * 1024; //200kb
    
    //    float factor;
    //    float currentResolution = image.size.height * image.size.width;
    
    //We first shrink the image a little bit in order to compress it a little bit more
    //    if (currentResolution > MIN_UPLOAD_RESOLUTION) {
    //        factor = sqrt(currentResolution / MIN_UPLOAD_RESOLUTION) * 2;
    //        image = [self scaleDown:image withSize:CGSizeMake(image.size.width / factor, image.size.height / factor)];
    //    }
    //Compression settings
    CGFloat compression = ratio;
    CGFloat maxCompression = maxRatio;
    
    //We loop into the image data to compress accordingly to the compression ratio
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > MAX_UPLOAD_SIZE && compression > maxCompression) {
        compression -= 0.05;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    return imageData;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+ (UIImage *)imageWithCusView:(UIView *)view
{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)imageFromText:(NSArray*)arrContent withFont:(UIFont *)font color:(UIColor *)color maxWidth:(CGFloat)maxWidth
{
    // set the font type and size
    CGFloat CONTENT_MAX_WIDTH = maxWidth ? maxWidth : [UIScreen mainScreen].bounds.size.width;
    
    NSMutableArray *arrHeight = [[NSMutableArray alloc] initWithCapacity:arrContent.count];
    NSMutableDictionary *strAttr = [NSMutableDictionary dictionary];
    [strAttr setObject:font forKey:NSFontAttributeName];
    [strAttr setObject:color forKey:NSForegroundColorAttributeName];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentLeft;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    [strAttr setObject:style forKey:NSParagraphStyleAttributeName];
    
    CGFloat fHeight = 0.0f;
    for (NSString *sContent in arrContent) {
        CGSize stringSize = [sContent  boundingRectWithSize:CGSizeMake(CONTENT_MAX_WIDTH, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:strAttr context:nil].size;
        
        [arrHeight addObject:[NSNumber numberWithFloat:stringSize.height]];
        fHeight += stringSize.height;
    }
    
    CGSize newSize = CGSizeMake(CONTENT_MAX_WIDTH+20, fHeight+50);
    
    UIGraphicsBeginImageContextWithOptions(newSize,NO,0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetCharacterSpacing(ctx, 10);
    
    CGContextSetTextDrawingMode (ctx, kCGTextFillStroke);
    
    CGContextSetRGBFillColor (ctx, 0.1, 0.2, 0.3, 1); // 6
    
    CGContextSetRGBStrokeColor (ctx, 0, 0, 0, 1);
    
    int nIndex = 0;
    
    CGFloat fPosY = 20.0f;
    
    for (NSString *sContent in arrContent) {
        
        NSNumber *numHeight = [arrHeight objectAtIndex:nIndex];
        
        CGRect rect = CGRectMake(10, fPosY, CONTENT_MAX_WIDTH , [numHeight floatValue]);
        
        [sContent drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:strAttr context:nil];
        
        fPosY += [numHeight floatValue];
        
        nIndex++;
        
    }
    
    // transfer image
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    return image;
}
#pragma mark - private
- (UIImage *)p_roundImageWithSize:(CGSize)size edgeWidth:(CGFloat)edgeWidth edgeColor:(UIColor *)color
{
    CGFloat widthRef = size.width + 2 * edgeWidth;
    CGFloat heightRef = size.height + 2 * edgeWidth;
    CGSize newSize = CGSizeMake(widthRef, heightRef);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    /** 画edge*/
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    [color set];
    [path fill];
    /** 裁剪image*/
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(edgeWidth, edgeWidth, size.width, size.height)];
    [path addClip];
//    [self drawAtPoint:CGPointMake(edgeWidth, edgeWidth)];
    [self drawInRect:CGRectMake(edgeWidth, edgeWidth, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)p_rounndImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width , size.height )];
    [path addClip];
//    [self drawAtPoint:CGPointZero];
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)p_cornerWithCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height)  byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    [path addClip];
    //    [self drawAtPoint:CGPointZero];
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)p_cornerWithRadius:(CGFloat)radius;
{
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius];
    [path addClip];
    //    [self drawAtPoint:CGPointZero];
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)p_rectImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width , size.height )];
    [path addClip];
    //    [self drawAtPoint:CGPointZero];
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *  根据CGImageRef来创建一个ARGBBitmapContext
 */
- (CGContextRef)p_ARGBBitmapContextFromImage:(CGImageRef) inImage {
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    NSInteger             bitmapByteCount;
    NSInteger             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    //colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);  //deprecated
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

@end
