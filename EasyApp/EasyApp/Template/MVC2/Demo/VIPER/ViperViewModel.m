//
//  ViperViewModel.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/2/6.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "ViperViewModel.h"
#import "ViperVm.h"
#import "ViperRouter.h"

@implementation ViperViewModel

- (void)dealloc
{
    NSLog(@"%@ -- dealloc", NSStringFromClass(self.class));
}
#pragma mark - branch
//无业务切分，无需绑定其他的, 均return self
- (void)bind:(id<Branch>)branch{
    self.controller = branch;
    
    self.vmodel = [[ViperVm alloc]init];
    self.route = [[ViperRouter alloc]init];
    [self.vm bind:self];
    [self.router bind:self];
    
    self.tableView.dataSource = self.vmodel;
    self.tableView.delegate = self.controller;
    self.titleView.delegate = self.controller;
    self.detailView.delegate = self.controller;
}
- (id<Branch>)nextBranch {
    return self.controller;
}
- (id<Branch>)request:(id)info response:(void(^)(id<Branch>, id info))response
{
    return self.nextBranch;
}
- (id<Controller_vm>)vm
{
    return self.vmodel;
}
- (id<Controller_i>)interactor
{
    return self.controller;
}
- (id<Controller_p>)presenter
{
    return self;
}
- (id<Controller_r>)router
{
    return self.route;
}
#pragma mark - present
- (void)clear
{
    self.titleView.text = nil;
    self.detailView.text = nil;
}
- (void)alert:(NSString *)string title:(NSString *)title
{
    UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:title message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerView show];
}

- (void)doAddSubView {
    
    [self.bindingView addSubview:self.titleView];
    [self.bindingView addSubview:self.detailView];
    [self.bindingView addSubview:self.submitBtn];
    [self.bindingView addSubview:self.tableView];
    [self.bindingView addSubview:self.exitBtn];
}
- (void)setNeedUpdateConstraints {
    [self setUpdateViewConstraints];
    [self.bindingView setNeedsUpdateConstraints];
}

- (void)makeViewConstraints {
    //make
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.titleView.superview;
        make.left.equalTo(superView).offset(12);
        make.right.equalTo(superView).offset(-12);
        make.top.equalTo(superView).offset(28);
        make.height.mas_equalTo(40);
    }];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.detailView.superview;
        make.left.equalTo(superView).offset(12);
        make.right.equalTo(superView).offset(-12);
        make.top.equalTo(self.titleView.mas_bottom).offset(8);
        make.height.mas_equalTo(80);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.submitBtn.superview;
        make.left.equalTo(superView).offset(12);
        make.right.equalTo(superView).offset(-12);
        make.top.equalTo(self.detailView.mas_bottom).offset(8);
        make.height.mas_equalTo(40);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.tableView.superview;
        make.left.equalTo(superView).offset(12);
        make.right.equalTo(superView).offset(-12);
        make.top.equalTo(self.submitBtn.mas_bottom).offset(8);
        make.bottom.equalTo(self.exitBtn.mas_top).offset(-8);
    }];
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.exitBtn.superview;
        make.left.equalTo(superView).offset(12);
        make.right.equalTo(superView).offset(-12);
        make.bottom.equalTo(superView).offset(-8);
        make.height.mas_equalTo(40);
    }];
}
- (void)setUpdateViewConstraints
{
    //add update constraints
    
}
- (UITextView *)titleView
{
    if (!_titleView)
    {
        _titleView = [[UITextView alloc]init];
        _titleView.text = @"title";
        _titleView.backgroundColor = [UIColor brownColor];
    }
    return _titleView;
}
- (UITextView *)detailView
{
    if (!_detailView)
    {
        _detailView = [[UITextView alloc]init];
        _detailView.text = @"detail";
        _detailView.backgroundColor = [UIColor brownColor];
    }
    return _detailView;
}
- (UIButton *)submitBtn
{
    if (!_submitBtn)
    {
        _submitBtn = [[UIButton alloc]init];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [UIColor orangeColor];
        [_submitBtn addTarget:self.interactor action:@selector(actionForView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
- (UIButton *)exitBtn
{
    if (!_exitBtn)
    {
        _exitBtn = [[UIButton alloc]init];
        [_exitBtn setTitle:@"exit" forState:UIControlStateNormal];
        [_exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _exitBtn.backgroundColor = [UIColor orangeColor];
        [_exitBtn addTarget:self.interactor action:@selector(actionForView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

@synthesize bindingView = _bindingView;

@synthesize tableView = _tableView;

@synthesize submitBtn = _submitBtn;

@synthesize titleView = _titleView;

@synthesize exitBtn = _exitBtn;

@synthesize detailView = _detailView;
@synthesize controller = _controller;

@synthesize vmodel = _vmodel;
@synthesize route = _route;

@end
