//
//  ControllerProtocol.h
//  EasyApp
//
//  Created by 靳小飞 on 2018/2/6.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "MVC2Base.h"

#define ControllerModule @"ControllerModule";//模块名

#pragma mark - 视图模型 VM
@protocol Controller_vm <VModel, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<NSString *> *dataSource;
- (NSString *)processString:(NSString *)str;
@end
#pragma mark - 交互器
@protocol Controller_i <Interactor, UITableViewDelegate, UITextViewDelegate>
@end
#pragma mark - 展示器
@protocol Controller_p <Presenter>
@property (nonatomic, strong) UITextView *titleView;
@property (nonatomic, strong) UITextView *detailView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *exitBtn;
@optional
- (void)clear;
- (void)alert:(NSString *)string title:(NSString *)title;
@end
#pragma mark - 路由 Router
@protocol Controller_r <Router>
- (void)routerToEditVc:(NSString *)str index:(NSInteger)index;
- (void)exit;
@end

#pragma mark - MVC
@protocol Controller_mvc
<Controller_vm,
Controller_i,
Controller_p,
Controller_r,
Context>
@end
#pragma mark - MVVM
@protocol Controller_Interactor <Controller_i, Controller_r, Context>
@end
@protocol Controller_ViewModel <Controller_vm, Controller_p, Context>
@end
#pragma mark - VIPER
@protocol VController_Interactor <Controller_i, Context>
@end
@protocol VController_ViewModel <Controller_p, Context>
@end
@protocol VController_Vm <Controller_vm, Context>
@end
@protocol VController_Router <Controller_r, Context>
@end



