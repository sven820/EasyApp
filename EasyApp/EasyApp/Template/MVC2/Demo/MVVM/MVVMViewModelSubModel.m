//
//  MVVMViewModelSubModel.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/3/10.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "MVVMViewModelSubModel.h"

@interface MVVMViewModelSubModel ()

@end

@implementation MVVMViewModelSubModel

@synthesize binder;
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self bind:[Binder new]];//新模块，有自己独立的binder
    }
    return self;
}
- (void)bind:(id<Binder>)binder {
    self.binder = binder;
    AddCtx(self);
}
- (void)exit
{
    [self.binder removeFromSuperBinder];
}
- (void)dealWithRequestInfo:(id<BranchRequest>)info cb:(BranchRequestCallBack)cb {
    
}

- (id<Branch>)request:(id<BranchRequest>)info cb:(BranchRequestCallBack)cb {
    return self;
}

@end
