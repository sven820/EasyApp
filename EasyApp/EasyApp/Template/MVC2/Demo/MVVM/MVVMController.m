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
//demo 编辑title 和 detail 提交到列表
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.viewModel bind:self];
    self.presenter.bindingView = self.view;
    [self.presenter doAddSubView];
    [self.presenter makeViewConstraints];
    
    [self initSetting];
    [self.presenter.tableView reloadData];
}
- (void)updateViewConstraints
{
    [self.presenter setUpdateViewConstraints];
    [super updateViewConstraints];
}
#pragma mark - private
- (void)initSetting
{
    self.vm.dataSource = [NSMutableArray array];
    [self.vm.dataSource addObject:@"title-detail"];
    self.view.backgroundColor = [UIColor brownColor];
}
- (BOOL)checkForSubmit
{
    if (self.presenter.titleView.text.length > 0 && self.presenter.detailView.text.length > 0) {
        return YES;
    }else{
        [self.presenter alert:@"title or detail empty!" title:@"waring"];
        return NO;
    }
}

#pragma mark - MvcController_mvc
- (void)bind:(id<Branch>)branch{
    self.viewModel = branch;
}
- (id<Branch>)nextBranch {
    return self;
}
- (id<Branch>)request:(id<Branch>)branch info:(id)info response:(void (^)(id))response {
    return self.nextBranch;
}
- (id<Controller_vm>)vm
{
    return self.viewModel;
}
- (id<Controller_i>)interactor
{
    return self;
}
- (id<Controller_p>)presenter
{
    return self.viewModel;
}
- (id<Controller_r>)router
{
    return self;
}
#pragma mark - router
- (void)routerToEditVc:(NSString *)str index:(NSInteger)index
{
    MvcTextEditController *vc = [[MvcTextEditController alloc]initWithText:str complete:^(NSString *newStr) {
        if ([newStr isEqualToString:str]) {
            
        }else if(newStr.length <= 0){
            [self.vm.dataSource removeObjectAtIndex:index];
            [self.presenter.tableView reloadData];
        }else{
            self.vm.dataSource[index] = newStr;
            [self.presenter.tableView reloadData];
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
    if (view == self.presenter.submitBtn) {
        if ([self checkForSubmit]) {
            NSString *str = [NSString stringWithFormat:@"%@-%@", self.presenter.titleView.text, self.presenter.detailView.text];
            [self.vm.dataSource addObject:[self.vm processString:str]];
            [self.presenter.tableView reloadData];
            
            [self.presenter clear];
        }
    }else if (view == self.presenter.exitBtn){
        [self.router exit];
    }
}

- (void)gestureRecongnizerForView:(UIGestureRecognizer *)recognizer {
    
}

//tabledelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *model = [self.vm.dataSource objectAtIndex:indexPath.row];
    
    [self.router routerToEditVc:model index:indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}
@synthesize viewModel = _viewModel;
- (id<Controller_ViewModel>)viewModel
{
    if (!_viewModel) {
        _viewModel = [[MVVMViewModel alloc]init];
    }
    return _viewModel;
}
@end
