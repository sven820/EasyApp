//
//  BaseViewModel.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/27.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "BaseViewModel.h"

@interface BaseViewModel ()
@property (nonatomic, weak) UIView *bindingView;
@property (nonatomic, strong) NSMutableArray *contexts;
@end

@implementation BaseViewModel
- (void)dealloc
{
    [self.contexts removeAllObjects];
    
    _contexts = nil;
}

- (instancetype)initWithDelegate:(id<VMDelegate>)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
        self.contexts = [NSMutableArray array];
    }
    return self;
}

//bind
- (void)bindView:(UIView *)view
{
    self.bindingView = view;
}
- (void)setBindingView:(UIView *)bindingView {
    if (_bindingView == bindingView) {
        return;
    }
    _bindingView = bindingView;
    //
    [self didBindView:_bindingView];
}
- (void)didBindView:(UIView*)bindingView {
    [bindingView setNeedsUpdateConstraints];
}
- (void)doBindContext {}
- (void)bindContext:(id<VMContext>)context didBind:(void(^)(id<VMContext> context))handle;
{
    [self.contexts addObject:context];
    if (handle) {
        handle(context);
    }
}
- (void)unbindContext:(id<VMContext>)context
{
    if ([self.contexts containsObject:context]) {
        [self.contexts removeObject:context];
    }
}
- (void)unbindContextWithCls:(Class)contextCls
{
    NSMutableArray *temp = [NSMutableArray array];
    for (id<VMContext> ctx in self.contexts) {
        if ([ctx isKindOfClass:contextCls]) {
            [temp addObject:ctx];
        }
    }
    [self.contexts removeObjectsInArray:temp];
}
//固定的约束
- (void)makeViewConstraints {}
//动态更新的约束
- (void)updateViewConstraints {}

- (void)setNeedUpdateConstraints
{
    [self.bindingView setNeedsUpdateConstraints];
}
@end
