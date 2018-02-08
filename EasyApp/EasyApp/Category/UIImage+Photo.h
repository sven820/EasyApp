//
//  UIImage+Photo.h
//  EasyApp
//
//  Created by 靳小飞 on 2018/2/8.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Photo)
+ (void)saveImage:(UIImage *)image errorBlock:(void(^)())errorOperation andSuccessBlock:(void(^)())successOperation;

@end
