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
#import "ViperController.h"

@interface MainViewController ()
{
    __weak id _delegate; //怎么做内存管理，用weak
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://cc.cocimg.com/api/uploads/20170227/1488160405920572.png"] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    
    dispatch_queue_t serialQueue = dispatch_queue_create("com.dullgrass.serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        NSLog(@"会执行的代码 --- %@",[NSThread currentThread]);
        
        dispatch_sync(serialQueue, ^{
            NSLog(@"代码不执行");
        });
    });
    
}

- (IBAction)tapButton:(id)sender {
//    MvcController *vc = [MvcController new];
//    MVVMController *vc = [MVVMController new];
    ViperController *vc = [ViperController new];

    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
