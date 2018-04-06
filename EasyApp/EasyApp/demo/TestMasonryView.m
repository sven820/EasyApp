//
//  TestMasonryView.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/4/4.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "TestMasonryView.h"

@interface TestMasonryView ()
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation TestMasonryView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleL = [UILabel new];
        self.titleL.text = @"titleL";
        
        self.clearBtn = [UIButton new];
        [self.clearBtn setTitle:@"clear" forState:UIControlStateNormal];
        
        self.contentView = [UIView new];
        self.contentView.backgroundColor = [UIColor greenColor];
        

        [self drawViews];
    }
    return self;
}
- (void)updateConstraints
{
    [self makeConstraints];
    [super updateConstraints];
}
- (void)drawViews
{
    [self addSubview:self.titleL];
    [self addSubview:self.clearBtn];
    [self addSubview:self.contentView];
}
-(void)makeConstraints
{
    [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.titleL.superview;
        make.left.equalTo(superView).offset(8);
        make.top.equalTo(superView).offset(8);
        make.height.equalTo(@40);
    }];
    [self.clearBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.clearBtn.superview;
        make.left.equalTo(self.titleL).offset(8);
        make.top.equalTo(superView).offset(8);
        make.height.equalTo(@40);
        make.right.equalTo(superView).offset(-8);
    }];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.contentView.superview;
        make.left.equalTo(superView).offset(8);
        make.right.equalTo(superView).offset(-8);
        make.top.equalTo(self.titleL.mas_bottom).offset(8);
        make.bottom.equalTo(superView).offset(-8);
        make.width.equalTo(@200);
        make.height.equalTo(@200);
    }];
}

@end
