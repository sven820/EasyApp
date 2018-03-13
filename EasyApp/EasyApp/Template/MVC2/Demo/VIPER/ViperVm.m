//
//  ViperVm.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/2/7.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "ViperVm.h"

@implementation ViperVm
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

- (id<Branch>)request:(id)info response:(void(^)(id<Branch>, id info))response
{
    return self.nextBranch;
}

- (id<Controller_i>)interactor {
    return self.viewModel.controller;
}

- (id<Controller_p>)presenter {
    return self.viewModel;
}

- (id<Controller_r>)router {
    return self.viewModel.router;
}

- (id<Controller_vm>)vm {
    return self;
}

#pragma mark - vm
//tabledatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vm.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *model = [self.vm.dataSource objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    cell.textLabel.text = model;
    cell.backgroundColor = [UIColor greenColor];
    [cell setNeedsUpdateConstraints];
    return cell;
}
- (NSString *)processString:(NSString *)str {
    return [NSString stringWithFormat:@"%@-processed", str];
}
@synthesize dataSource;

@synthesize viewModel;

@end
