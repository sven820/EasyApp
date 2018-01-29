//
//  DemoView.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/27.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "DemoView.h"

@implementation DemoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawViews];
        [self makeConstraints];
    }
    return self;
}
- (void)drawViews
{
    
}

-(void)makeConstraints
{
    //固定不变的约束
}

- (void)updateConstraints
{
    //动态更新的约束
    [super updateConstraints];
}

@end
