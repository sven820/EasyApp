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
@protocol Branch <NSObject>
- (void)bind:(id<Branch>)branch;
/**
 * return -> 由于我是按照viper操作流来定制协议的，所以这里return下一节点的branch，为了方便链式调用
 */
- (id<Branch>)request:(id<Branch>)branch info:(id)info response:(void(^)(id info))response;
- (id<Branch>)nextBranch;
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

//注意分支分支持有的实体对象不要和下面relationship的名字重名，不然容易发生循环调用
//relationship是不安全的，返回可能为空，在relationship种返回具体的实例对象，实例对象在分支种持有,比如MVVM_Interactor持有viewModel，通过分支来获取则是安全的
@protocol relationship <Branch>
- (id<Branch>)vm;
- (id<Branch>)interactor;
- (id<Branch>)presenter;
- (id<Branch>)router;
@end
#pragma mark - MVC
@protocol MVC <Name_Presenter, Name_Interactor, Name_VModel, Name_Router>
@end

#pragma mark - MVVM
@protocol MVVM_VM;
@protocol MVVM_Interactor <Name_Interactor, Name_Router>
@property (nonatomic, strong) id<MVVM_VM> viewModel;
@end
@protocol MVVM_VM <Name_VModel, Name_Presenter>
@property (nonatomic, weak) id<MVVM_Interactor> context;
@end

#pragma mark - VIPER
@protocol VIPER_Interactor;
@protocol VIPER_ViewModel;
@protocol VIPER_Vm;
@protocol VIPER_Router;

@protocol VIPER_Interactor <Name_Interactor>
@property (nonatomic, strong) id<VIPER_ViewModel> viewModel;
@end
@protocol VIPER_ViewModel <Name_Presenter>
@property (nonatomic, weak) id<VIPER_Interactor> context;

@property (nonatomic, strong) id<VIPER_Vm> vmodel;
@property (nonatomic, strong) id<VIPER_Router> r;
@end
@protocol VIPER_Vm <Name_VModel>
@property (nonatomic, weak) id<VIPER_ViewModel> viewModel;
@end
@protocol VIPER_Router <Name_Router>
@property (nonatomic, weak) id<VIPER_ViewModel> viewModel;
@end


