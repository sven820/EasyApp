//
//  MVC2Config.h
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/29.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVC2Protocol.h"

#pragma mark - branch
@interface Branch : NSObject <Branch>
@end

#pragma mark - 展示器
/**
 *  展示器
 *
 *  布局 动画 动态更新布局等
 */
@interface Presenter : NSObject <Presenter>
@end

#pragma mark - 视图模型
/**
 *  视图模型
 *
 *  视图model数据绑定
 */
@interface ViewModel : NSObject <VModel>
@end

#pragma mark - 交互器
/**
 *  交互器
 *
 *  与视图交互
 */
@interface Interacter : NSObject <Interactor>
@end

@interface ViewController : UIViewController <Interactor>
@end







