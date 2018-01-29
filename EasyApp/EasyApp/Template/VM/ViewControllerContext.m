//
//  ViewControllerContext.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/28.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "ViewControllerContext.h"

@implementation ViewEditContext
- (instancetype)initWithIdentify:(NSString *)identify
{
    if (self == [super init]) {
        self.identify = identify;
    }
    return self;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
}
@end

@implementation ViewListContext
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = [NSMutableArray array];
        [self.dataSource addObject:@"test_1"];
        [self.dataSource addObject:@"test_2"];
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.dataSource[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = str;
    [cell setNeedsUpdateConstraints];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
