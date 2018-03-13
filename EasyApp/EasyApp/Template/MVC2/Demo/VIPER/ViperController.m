//
//  ViperController.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/2/6.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "ViperController.h"
#import "ControllerProtocol.h"
#import "ViperViewModel.h"

@interface ViperController ()<VController_Interactor>

@end

@implementation ViperController
@synthesize viewModel = _viewModel;
- (void)dealloc
{
    NSLog(@"%@ -- dealloc", NSStringFromClass(self.class));
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewModel = [[ViperViewModel alloc]init];
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
#pragma mark - branch
- (void)bind:(id<Branch>)branch {
    self.viewModel = branch;
}

- (id<Branch>)nextBranch {
    return self.viewModel;
}

- (id<Branch>)request:(id)info response:(void(^)(id<Branch>, id info))response
{
    return self.nextBranch;
}

- (id<Controller_i>)interactor {
    return self;
}

- (id<Controller_p>)presenter {
    return self.viewModel;
}

- (id<Controller_r>)router {
    return self.viewModel.router;
}

- (id<Controller_vm>)vm {
    return self.viewModel.vmodel;
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
@end
