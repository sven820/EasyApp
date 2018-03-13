//
//  MVC2Protocol.h
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/29.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

/**
 *  MVC2
 *  MVC2是为了解决编码过程中架构选型与app时间线上不对称，复杂度不对称问题，如果采用单一架构模式，则会出现架构调整或升级不便的问题，MVC2旨在改善这一问题
    同时MVC2采用面向协议和分布式的编程规范，旨在提高代码的高可读性，高可测试性和高精度性
    All you can custom!
        按照MVC2的架构设计思想，你完全可以根据自己的习惯或业务需求来定制自己的协议簇和基协议，这是十分必要的
    (由于个人能力有限，忘大家积极提出改进建议，谢谢， 作者：sven，微信：jinxiaofei003, 交流群：)
 *
 *  基本编程思想 面向协议，分布式架构模型，由于采用分支协议簇的方式，使得后续升级时，对代码迁移，将十分方便，具体参见demo mvc->mvvm->viper
        1.branch 基协议，定义不同功能分支间的交互方式
        2.分支协议簇 present, interactor, viewmodel, router...(you can custom)
             present: 该协议下定义视图相关的接口
             interactor:定义交互接口
             viewmodel:定义视图模型数据
             router:定义路由系统
             ...(your custom)
        3.基于分支基协议簇的3种典型架构基协议（you can custom）
 mvc: mvc架构协议簇，present，interactor，viewmodel，router...基本都在一个上下文中处理，适用于快速构建简单业务模块

 mvvm: mvvm架构协议簇, 适用于构建较复杂业务
             MVVM_Interactor:interactor + router...
             MVVM_VM: present + viewmodel...
             ...(you can custom)

 viper: viper架构协议簇，适用于构建复杂业务
             present:
             interactor:
             viewmodel:
             router:
             ...(you can custom)
 */

//base protocol
//这里按照viper架构的操作流来定义协议簇 vm -> interactor -> present -> router -> vm
#pragma mark - 根协议
/**
 *  Context 上下文 通常为业务切分的某个类对象，例如controller就是一个context
 */
@protocol Context <NSObject>
@end
/**
 *  Branch分支 代表不同模块的根协议
 *  与context区别，Branch是逻辑上的，Context是对象层面的，有实体，
    所以branches用NSMapTable弱引用，contexts用NSMutableDictionary，强引用
 */
@protocol Branch;
@protocol BranchRequest;
@class Binder;
typedef void(^BranchRequestCallBack)(id<Branch> branch, id<BranchRequest> cbInfo);

@protocol Binder <NSObject>
+ (instancetype)binderWithModule:(NSString *)module;
- (void)unBind;
//NSMapTable可以设置弱引用，但速度比dict慢2倍，但一般我们一个节点里面不会绑定太多子节点，所以不会很影响性能
@property (nonatomic, strong) NSString *module;//binder对应的模块
@property (nonatomic, strong) NSMapTable *branches;

@property (nonatomic, weak) Binder *superBinder;
@property (nonatomic, strong) NSMutableArray<Binder *> *subBinders;//unBind 后，会全部移除
- (void)addSubBinder:(Binder *)binder;
- (void)removeFromSuperBinder;

- (void)bind:(id<Branch>)branch protocol:(Protocol *)protocol;
- (void)bind:(id<Branch>)branch protocol:(Protocol *)protocol identity:(NSString *)identity;
- (void)unbind:(Protocol *)protocol;
- (void)unbind:(Protocol *)protocol identity:(NSString *)identity;
- (id<Branch>)branch:(Protocol *)protocol;
- (id<Branch>)branch:(Protocol *)protocol identity:(NSString *)identity;
@optional
@property (nonatomic, strong) NSMutableDictionary *contexts;
- (void)addCtx:(id<Context>)ctx;
- (void)addCtx:(id<Context>)ctx identity:(NSString *)identity;
- (void)removeCtx:(Class)cls;
- (void)removeCtx:(Class)cls identity:(NSString *)identity;
- (id<Context>)ctx:(Class)cls;
- (id<Context>)ctx:(Class)cls identity:(NSString *)identity;
@end
@protocol BranchRequest <NSObject>
@property (nonatomic, strong) NSString *module;//模块
@property (nonatomic, strong) NSString *branch;//分支
@property (nonatomic, assign) SEL action;//消息
@property (nonatomic, weak) id target;//处理消息的对象
@property (nonatomic, strong) id info;//消息数据
@end

@protocol Branch <NSObject>
//bind branch, binder创建的branch中一定要收动unbind，时机是模块退出时
@property (nonatomic, weak) id<Binder> binder;
- (void)bind:(id<Binder>)binder;
#define Bind(branch, p)     [self.binder bind:branch protocol:@protocol(p)]
#define Unbind(p)           [self.binder unbind:@protocol(p)]
#define Branch(p)           ((id<p>)[self.binder branch:@protocol(p)])

#define Bind_identify(branch, p, identify)     [self.binder bind:branch protocol:@protocol(p) identity:identify]
#define Unbind_identify(p, identify)           [self.binder unbind:@protocol(p) identity:identify]
#define Branch_identify(p, identify)           ((id<p>)[self.binder branch:@protocol(p) identity:identify])

#define AddCtx(ctx)         [self.binder addCtx:ctx]
#define RemoveCtx(cls)      [self.binder removeCtx:[cls class]]
#define Ctx(cls)            ((cls *)[self.binder ctx:[cls class]])

#define AddCtx_identify(ctx, identify)         [self.binder addCtx:ctx identity:identify]
#define RemoveCtx_identify(cls, identify)      [self.binder removeCtx:[cls class] identity:identify]
#define Ctx_identify(cls, identify)            ((cls *)[self.binder ctx:[cls class] identity:identify])
/** 伪链式调用
 * return self
 */
- (id<Branch>)request:(id<BranchRequest>)info cb:(BranchRequestCallBack)cb;
/**
 *  消息分发
 *
 *  @param info request或BranchChainCallBack中的request info
 *  @param cb info消息处理后cb
 */
- (void)dealWithRequestInfo:(id<BranchRequest>)info cb:(BranchRequestCallBack)cb;
@optional
//模拟链式调用
- (id<Branch> (^)(id<BranchRequest> info, BranchRequestCallBack cb))request;
//解绑binder，可以不实现，但一定在实例binder的branch中解绑binder
- (void)unbind;
@end

#pragma mark - 展示器
@protocol Presenter <Branch>
//所绑定的视图容器
@property (nonatomic, weak, setter=setBindingView:) UIView *bindingView;
- (void)setNeedUpdateConstraints;

- (void)doAddSubView;
- (void)makeViewConstraints;
- (void)setUpdateViewConstraints;
@optional
@end

#pragma mark - 交互器
@protocol Interactor <Branch>
@optional
- (void)actionForView:(UIView *)view;
- (void)gestureRecongnizerForView:(UIGestureRecognizer *)recognizer;
@end

#pragma mark - 视图模型 VM
@protocol VModel <Branch>
@end

#pragma mark - 路由 Router
@protocol Router <Branch>
@end


#pragma mark - 以下为3种架构模式方案的模板，使用时候可根据自己实际需求和习惯自定义
#pragma mark - 展示器
@protocol Name_Presenter <Presenter>
@end
#pragma mark - 交互器
@protocol Name_Interactor <Interactor>
@end
#pragma mark - 视图模型 VM
@protocol Name_VModel <VModel>
@end
#pragma mark - 路由 Router
@protocol Name_Router <Router>
@end
/**
 *  3种架构协议模式
 *
 *  - 以下架构需要在具体模块中定制，采用面向协议模式开发，具体参见mvc，mvvm和viper的demo中演示
 *  //note: vm单指model数据， viewModel指包含present的viewModel封装集合
 */
#pragma mark - MVC
@protocol MVC <Name_Presenter, Name_Interactor, Name_VModel, Name_Router, Context>
@end

#pragma mark - MVVM
@protocol MVVM_Interactor <Name_Interactor, Name_Router, Context>
@end
@protocol MVVM_VM <Name_VModel, Name_Presenter, Context>
@end

#pragma mark - VIPER

@protocol VIPER_Interactor <Name_Interactor, Context>
@end
@protocol VIPER_ViewModel <Name_Presenter, Context>
@end
@protocol VIPER_Vm <Name_VModel, Context>
@end
@protocol VIPER_Router <Name_Router, Context>
@end


