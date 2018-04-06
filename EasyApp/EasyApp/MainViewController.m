//
//  ViewController.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/26.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "MainViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/UIImage+ForceDecode.h>


#import "MvcController.h"
#import "MVVMController.h"
#import "NSObject+JsonHelp.h"
//#import "ViperController.h"
#import "TestMasonryView.h"

@interface MainViewController ()
{
    __weak id _delegate; //怎么做内存管理，用weak
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) TestMasonryView *testMasonryView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.testMasonryView = [TestMasonryView new];
    [self.view addSubview:self.testMasonryView];
    
    [self.testMasonryView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.testMasonryView.superview;
        make.left.equalTo(superView).offset(8);
        make.top.equalTo(superView).offset(100);
    }];
}
- (void)updateViewConstraints
{
    
    [super updateViewConstraints];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view setNeedsUpdateConstraints];
    //    MvcController *vc = [MvcController new];
    MVVMController *vc = [MVVMController new];
    //    ViperController *vc = [ViperController new];
    
//    [self presentViewController:vc animated:YES completion:nil];
}


@end
