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

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://cc.cocimg.com/api/uploads/20170227/1488160405920572.png"] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        UIImage *i = [UIImage decodedImageWithImage:image];
        
        NSData *d = UIImagePNGRepresentation(image);
        //43029
        NSLog(@"%zd",d.length);
    }];
    
    UIImage *image = [UIImage imageNamed:@"1488160405920572"];
    NSData *d = UIImagePNGRepresentation(image);
    //43029
    NSLog(@"%zd",d.length);
    
    return;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:@"http://cc.cocimg.com/api/uploads/20170227/1488160405920572.png"] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        UIImage *i = [UIImage decodedImageWithImage:image];
        
        self.imageView.image = image;
        
        NSData *d = UIImagePNGRepresentation(i);
        //43029
        NSLog(@"%zd---%zd",d.length, data.length);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
