//
//  BaseViewModel.h
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/27.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YXYViewModel;
@protocol VMDelegate; ;
@protocol VMContext;

//相当于展示器 p => vc
@protocol VMDelegate <NSObject>
@optional
- (void)viewModel:(YXYViewModel *)viewModel handleWithInfo:(id)handleInfo;
- (void)vmContext:(id<VMContext>)vmContext handleWithInfo:(id)handleInfo;
@end

//相当于交互器 i => 业务交互代码
@protocol VMContext <NSObject>
@property (nonatomic, weak) id<VMDelegate> delegate;

@optional
@property (nonatomic, strong) NSString *identify;
@property (nonatomic, weak) UIView *bindView;


@end


//mvvm => viper架构
@interface BaseViewModel : NSObject

- (instancetype)initWithDelegate:(id<VMDelegate>)delegate;
@property (nonatomic, weak) id<VMDelegate> delegate;

//bind
- (void)bindView:(UIView *)view;
@property (nonatomic, weak, readonly) UIView *bindingView;

- (void)doBindContext;//rewrite
- (void)bindContext:(id<VMContext>)context didBind:(void(^)(id<VMContext> context))handle;
- (void)unbindContext:(id<VMContext>)context;
- (void)unbindContextWithCls:(Class)contextCls;
/**
 *  self.bindingView改变时会被回调
 *
 *  @param bindingView 新绑定的只
 */
- (void)didBindView:(UIView*)bindingView;

/**
 *  调用前要确保bindingView已绑定视图
 */
- (void)makeViewConstraints;
- (void)updateViewConstraints;
- (void)setNeedUpdateConstraints;
@end
