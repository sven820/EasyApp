//
//  MvcTextEditController.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/2/1.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "MvcTextEditController.h"
#import "MVC2Base.h"

@interface MvcTextEditController ()<Presenter>
@property (nonatomic, strong) UITextView *editView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, copy) void(^complete)(NSString *str);
@end

@implementation MvcTextEditController
@synthesize bindingView;
- (void)dealloc
{
    NSLog(@"%@ -- dealloc", NSStringFromClass(self.class));
}
- (instancetype)initWithText:(NSString *)text complete:(void (^)(NSString *))complete
{
    if (self = [super init]) {
        self.complete = complete;
        self.editView.text = text;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bindingView = self.view;
    [self doAddSubView];
    [self makeViewConstraints];
}
- (void)updateViewConstraints
{
    [self setNeedUpdateConstraints];
    [super updateViewConstraints];
}
#pragma mark - action
- (void)actionForSubmit
{
    if (self.complete) {
        self.complete(self.editView.text);
        
        _complete = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - branch
- (void)bind:(id<Branch>)branch {}

- (id<Branch>)nextBranch {
    return nil;
}
- (id<Branch>)request:(id)info response:(void(^)(id<Branch>, id info))response
{
    return nil;
}
#pragma mark - present
- (void)doAddSubView {
    [self.bindingView addSubview:self.editView];
    [self.bindingView addSubview:self.submitBtn];
}
- (void)setNeedUpdateConstraints {
    [self setUpdateViewConstraints];
    [self.view setNeedsUpdateConstraints];
}
- (void)makeViewConstraints {
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.editView.superview;
        make.top.equalTo(superView).offset(28);
        make.left.equalTo(superView).offset(12);
        make.right.equalTo(superView).offset(-12);
        make.height.mas_equalTo(100);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.submitBtn.superview;
        make.top.equalTo(self.editView.mas_bottom).offset(8);
        make.left.equalTo(superView).offset(12);
        make.right.equalTo(superView).offset(-12);
        make.height.mas_equalTo(40);
    }];
}
- (void)setUpdateViewConstraints
{
    //add update Constraints;
}
- (UITextView *)editView
{
    if (!_editView)
    {
        _editView = [[UITextView alloc]init];
        _editView.backgroundColor = [UIColor brownColor];
    }
    return _editView;
}
- (UIButton *)submitBtn
{
    if (!_submitBtn)
    {
        _submitBtn = [[UIButton alloc]init];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [UIColor orangeColor];
        [_submitBtn addTarget:self action:@selector(actionForSubmit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

@end
