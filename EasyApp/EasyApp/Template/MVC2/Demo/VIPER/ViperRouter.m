//
//  ViperRouter.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/2/6.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "ViperRouter.h"
#import "MvcTextEditController.h"

@implementation ViperRouter

@synthesize viewModel;
- (void)dealloc
{
    NSLog(@"%@ -- dealloc", NSStringFromClass(self.class));
}
- (void)bind:(id<Branch>)branch {
    self.viewModel = branch;
}

- (id<Branch>)nextBranch {
    return self.viewModel;
}

- (id<Branch>)request:(id<Branch>)branch info:(id)info response:(void (^)(id))response {
    return self.nextBranch;
}

- (id<Controller_i>)interactor {
    return self.viewModel.controller;
}

- (id<Controller_p>)presenter {
    return self.viewModel;
}

- (id<Controller_r>)router {
    return self;
}

- (id<Controller_vm>)vm {
    return self.viewModel.vm;
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
    [(UIViewController *)self.interactor presentViewController:vc animated:YES completion:nil];
}
- (void)exit
{
    [(UIViewController *)self.interactor dismissViewControllerAnimated:YES completion:nil];
}
@end
