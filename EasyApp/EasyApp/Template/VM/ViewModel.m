//
//  ViewModel.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/27.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "ViewModel.h"
#import "ViewControllerContext.h"

@interface ViewModel ()
@property (nonatomic, strong) UITextView *titleView;
@property (nonatomic, strong) UITextView *detailView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewModel
//简单界面无需细分context的，此步骤省去，只保留viewModel
- (void)doBindContext
{
    [self bindContext:[[ViewEditContext alloc]initWithIdentify:@"identify_title"] didBind:^(id<VMContext> context) {
        self.titleView.delegate = (ViewEditContext *)context;
    }];
    [self bindContext:[[ViewEditContext alloc]initWithIdentify:@"identify_detail"] didBind:^(id<VMContext> context) {
        self.detailView.delegate = (ViewEditContext *)context;

    }];
    [self bindContext:[[ViewListContext alloc]init] didBind:^(id<VMContext> context) {
        self.tableView.delegate = (ViewListContext *)context;
        self.tableView.dataSource = (ViewListContext *)context;
    }];
}
- (void)didBindView:(UIView *)bindingView
{
    [super didBindView:bindingView];
    //draw view
    [self drawViews];
    
    //delegate
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.editView.delegate = self;
}
- (void)drawViews
{
    [self.bindingView addSubview:self.titleView];
    [self.bindingView addSubview:self.detailView];
    [self.bindingView addSubview:self.submitBtn];
    [self.bindingView addSubview:self.tableView];
}
- (void)makeViewConstraints
{
    [super makeViewConstraints];
    //make
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.titleView.superview;
        make.left.equalTo(superView).offset(12);
        make.right.equalTo(superView).offset(-12);
        make.top.equalTo(superView).offset(72);
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
        make.top.equalTo(self.detailView).offset(8);
        make.height.mas_equalTo(40);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.tableView.superview;
        make.left.equalTo(superView).offset(12);
        make.right.equalTo(superView).offset(-12);
        make.top.equalTo(self.submitBtn).offset(8);
        make.bottom.equalTo(superView).offset(-8);
    }];
}
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    //update 
}
#pragma mark - get
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
    }
    return _submitBtn;
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
@end
