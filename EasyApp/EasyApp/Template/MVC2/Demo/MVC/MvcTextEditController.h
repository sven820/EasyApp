//
//  MvcTextEditController.h
//  EasyApp
//
//  Created by 靳小飞 on 2018/2/1.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MvcTextEditController : UIViewController
- (instancetype)initWithText:(NSString *)text complete:(void(^)(NSString *str))complete;
@end
