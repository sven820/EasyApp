//
//  MvcController.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/30.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "MvcController.h"
#import "ControllerProtocol.h"

#import "MvcTextEditController.h"

@interface MvcController ()<Controller_mvc>
@end

@implementation MvcController
- (void)dealloc
{
    NSLog(@"%@ -- dealloc", NSStringFromClass(self.class));
}
//demo 编辑title 和 detail 提交到列表
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self bind:[Binder new]];
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
//无业务切分，无需绑定其他的, 均return self
- (void)bind:(id<Binder>)binder
{
    self.binder = binder;
    
    Bind(self, Controller_vm);
    Bind(self, Controller_p);
    Bind(self, Controller_i);
    Bind(self, Controller_r);
    
    self.tableView.dataSource = Branch(Controller_vm);
    self.tableView.delegate = Branch(Controller_i);
    self.titleView.delegate = Branch(Controller_i);
    self.detailView.delegate = Branch(Controller_i);
}

- (id<Branch>)request:(id<BranchRequest>)info cb:(BranchRequestCallBack)cb
{
    //deal info
    [self dealWithRequestInfo:info cb:cb];

    return self;
}
- (id<Branch> (^)(id<BranchRequest> info, BranchRequestCallBack cb))request
{
    return ^id<Branch> (id<BranchRequest> info, BranchRequestCallBack cb) {
        
        [self dealWithRequestInfo:info cb:cb];
        
        return self;
    };
}
- (void)dealWithRequestInfo:(id<BranchRequest>)info cb:(BranchRequestCallBack)cb
{
    BranchRequest *cbInfo = [BranchRequest new];
    id<Branch> b = self;
    if (cb) {
        cb(b, cbInfo);
    }
}
- (void)branchRequestAndResponseTest
{
    BranchRequest *info;
    
    //伪链式调用
    [[[Branch(Controller_vm) request:info cb:^(id<Branch> branch, id<BranchRequest> cbinfo) {
        
    }] request:info cb:^(id<Branch> branch, id<BranchRequest> cbinfo) {
        
    }] request:info cb:^(id<Branch> branch, id<BranchRequest> cbinfo) {
        
    }];
    
    //链式调用
    Branch(Controller_vm).request(info, ^void(id<Branch> branch, id<BranchRequest> cbinfo){
        
    }).request(info, ^void(id<Branch> branch, id<BranchRequest> cbinfo){
        
    });
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
#pragma mark - vm
//tabledatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Branch(Controller_vm).dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *model = [Branch(Controller_vm).dataSource objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    cell.textLabel.text = model;
    cell.backgroundColor = [UIColor greenColor];
    [cell setNeedsUpdateConstraints];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}
- (NSString *)processString:(NSString *)str {
    return [NSString stringWithFormat:@"%@-processed", str];
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
    [self.view setNeedsUpdateConstraints];
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
        [_submitBtn addTarget:Branch(Controller_i) action:@selector(actionForView:) forControlEvents:UIControlEventTouchUpInside];
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
        [_exitBtn addTarget:Branch(Controller_i) action:@selector(actionForView:) forControlEvents:UIControlEventTouchUpInside];
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

@synthesize dataSource = _dataSource;

@synthesize tableView = _tableView;

@synthesize submitBtn = _submitBtn;

@synthesize titleView = _titleView;

@synthesize exitBtn = _exitBtn;

@synthesize detailView = _detailView;

@synthesize binder = _binder;
@end
