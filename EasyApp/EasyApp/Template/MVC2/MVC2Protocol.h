//
//  MVC2Protocol.h
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/29.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

/**
 *  MVC2
 *  MVC2是为了解决
        1.app业务切分
        2.业务复杂度提升后的业务切分的易重构性
        3.完全面向协议编程
 *  按照MVC2的架构设计思想，你完全可以根据自己的习惯或业务需求来定制自己的协议簇和基协议，这是十分必要的
 
 *  相关名词释义
    基协议
        Context - 定义业务的实现的上下文，表现为某个具体对象
        Branch  - 定义业务模块，是业务模块的根协议，属于逻辑上的模块划分，与context区别，Branch是逻辑上的，Context是对象层面的，有实体
                    - 所以binder中branches用NSMapTable弱引用，contexts用NSMutableDictionary，强引用
                - Branch 在上层主要定义了：1.模块绑定， 2.模块交互
        BranchRequest
                - 定义模块间交互信息和消息分发
        Binder  - 绑定，负责模块间的绑定和context的绑定，结构类似view的superview subviews这种
    协议簇
        Presenter（exp）
                - 定义某个模块的基协议，属于逻辑上的业务模块划分，与context不同
                - 协议簇是业务的上层基协议，是业务拆的过程，可根据实际自定义
                - 协议簇需要在具体模块内被继承，自定义，表现为接口形式暴露给外部
    业务根协议
        MVC（exp）
                - 是对协议簇组装的过程
                - 属于context级别
                - 负责定义context容器与协议簇之间的组装关系
                - 根据业务根协议构建业务代码
 
 */

#pragma mark - 基协议
/**
 *  Context 上下文 通常为业务切分的某个类对象，例如controller就是一个context
 */
@protocol Context <NSObject>
@end
/**
 *  Branch分支 代表不同模块的根协议
 *  与context区别，Branch是逻辑上的，Context是对象层面的，有实体，
 
 */
@protocol Branch;
@protocol BranchRequest;
@class Binder;
typedef void(^BranchRequestCallBack)(id<Branch> branch, id<BranchRequest> cbInfo);

@protocol Binder <NSObject>
+ (instancetype)binderWithModule:(NSString *)module;
+ (void)unBinderWithModule:(NSString *)module;
- (void)unBind;
//NSMapTable可以设置弱引用，但速度比dict慢2倍，但一般我们一个节点里面不会绑定太多子节点，所以不会很影响性能
@property (nonatomic, strong) NSString *module;//binder对应的模块
@property (nonatomic, strong) NSMapTable<NSString *,id<Branch>> *branches;

@property (nonatomic, weak) Binder *superBinder;
@property (nonatomic, strong) NSMutableArray<Binder *> *subBinders;//unBind 后，会全部移除
- (void)addSubBinder:(Binder *)binder;
- (void)removeSubBinders;
- (void)removeFromSuperBinder;

- (void)bind:(id<Branch>)branch protocol:(Protocol *)protocol;
- (void)bind:(id<Branch>)branch protocol:(Protocol *)protocol identity:(NSString *)identity;
- (void)unbind:(Protocol *)protocol;
- (void)unbind:(Protocol *)protocol identity:(NSString *)identity;
- (id<Branch>)branch:(Protocol *)protocol;
- (id<Branch>)branch:(Protocol *)protocol identity:(NSString *)identity;

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<Context>> *contexts;
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

@protocol Branch <Context>
///bind branch, binder创建的branch中一定要收动unbind，时机是模块退出时
@property (nonatomic, weak) id<Binder> binder;
///初始化各种ctx，branch对象等
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
@end

#pragma mark - 协议簇
#pragma mark -
//这里按照viper架构的操作流来定义协议簇 vm -> interactor -> present -> router -> vm
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

#pragma mark -  业务根协议
/**
 *  3种架构协议模式
 *
 *  - 以下架构需要在具体模块中定制，采用面向协议模式开发，具体参见mvc，mvvm和viper的demo中演示
 *  //note: vm单指model数据， viewModel指包含present的viewModel封装集合
 */
#pragma mark - MVC
@protocol MVC <Name_Presenter, Name_Interactor, Name_VModel, Name_Router>
@end

#pragma mark - MVVM
@protocol MVVM_Interactor <Name_Interactor, Name_Router>
@end
@protocol MVVM_VM <Name_VModel, Name_Presenter>
@end

#pragma mark - VIPER

@protocol VIPER_Interactor <Name_Interactor>
@end
@protocol VIPER_ViewModel <Name_Presenter>
@end
@protocol VIPER_Vm <Name_VModel>
@end
@protocol VIPER_Router <Name_Router>
@end


