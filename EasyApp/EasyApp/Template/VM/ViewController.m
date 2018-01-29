//
//  ViewController.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/27.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) ViewModel *viewModel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //bind view
    [self.viewModel bindView:self.view];
    //固定约束
    [self.viewModel makeViewConstraints];
}
- (void)updateViewConstraints
{
    //需动态更新约束
    [self.viewModel updateViewConstraints];
    [super updateViewConstraints];
}
- (void)viewModel:(YXYViewModel *)viewModel handleWithInfo:(id)handleInfo
{
    //比如有编辑和浏览两个业务
    
    //编辑
    
    //列表展示
}

- (ViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ViewModel alloc]initWithDelegate:self];
    }
    return _viewModel;
}
@end



