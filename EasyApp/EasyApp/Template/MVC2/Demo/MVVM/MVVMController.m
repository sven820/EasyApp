//
//  MVVMController.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/30.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "MVVMController.h"
#import "MVVMViewModel.h"
#import "MvcTextEditController.h"

@interface MVVMController ()

@end

@implementation MVVMController
- (void)dealloc
{
    NSLog(@"%@ -- dealloc", NSStringFromClass(self.class));
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.binder unBind];
}
//demo 编辑title 和 detail 提交到列表
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self bind:[Binder binderWithModule:NSStringFromClass(self.class)]];
    
    Branch(Controller_p).bindingView = self.view;
    [Branch(Controller_p) doAddSubView];
    [Branch(Controller_p) makeViewConstraints];
    
    [self initSetting];
    [Branch(Controller_p).tableView reloadData];
}
- (void)updateViewConstraints
{
    [Branch(Controller_p) setUpdateViewConstraints];
    [super updateViewConstraints];
}
#pragma mark - private
- (void)initSetting
{
    Branch(Controller_vm).dataSource = [NSMutableArray array];
    [Branch(Controller_vm).dataSource addObject:@"title-detail"];
    self.view.backgroundColor = [UIColor brownColor];
}
- (BOOL)checkForSubmit
{
    if (Branch(Controller_p).titleView.text.length > 0 && Branch(Controller_p).detailView.text.length > 0) {
        return YES;
    }else{
        [Branch(Controller_p) alert:@"title or detail empty!" title:@"waring"];
        return NO;
    }
}

#pragma mark - MvcController_mvc
- (void)bind:(id<Binder>)binder
{
    self.binder = binder;
    AddCtx(self);
    
    Bind(self, Controller_i);
    Bind(self, Controller_r);
    
    [[MVVMViewModel new] bind:binder];
}
- (id<Branch>)request:(id<BranchRequest>)info cb:(BranchRequestCallBack)cb
{
    //deal info
    [self dealWithRequestInfo:info cb:cb];
    
    return self;
}
- (void)dealWithRequestInfo:(id<BranchRequest>)info cb:(BranchRequestCallBack)cb
{
    
}
#pragma mark - router
- (void)routerToEditVc:(NSString *)str index:(NSInteger)index
{
    MvcTextEditController *vc = [[MvcTextEditController alloc]initWithText:str complete:^(NSString *newStr) {
        if ([newStr isEqualToString:str]) {
            
        }else if(newStr.length <= 0){
            [Branch(Controller_vm).dataSource removeObjectAtIndex:index];
            [Branch(Controller_p).tableView reloadData];
        }else{
            Branch(Controller_vm).dataSource[index] = newStr;
            [Branch(Controller_p).tableView reloadData];
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)exit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - interactor
- (void)actionForView:(UIView *)view
{
    if (view == Branch(Controller_p).submitBtn) {
        if ([self checkForSubmit]) {
            NSString *str = [NSString stringWithFormat:@"%@-%@", Branch(Controller_p).titleView.text, Branch(Controller_p).detailView.text];
            [Branch(Controller_vm).dataSource addObject:[Branch(Controller_vm) processString:str]];
            [Branch(Controller_p).tableView reloadData];
            
            [Branch(Controller_p) clear];
        }
    }else if (view == Branch(Controller_p).exitBtn){
        [Branch(Controller_r) exit];
    }
}

- (void)gestureRecongnizerForView:(UIGestureRecognizer *)recognizer {
    
}

//tabledelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *model = [Branch(Controller_vm).dataSource objectAtIndex:indexPath.row];
    
    [Branch(Controller_r) routerToEditVc:model index:indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

@synthesize binder = _binder;

@end
