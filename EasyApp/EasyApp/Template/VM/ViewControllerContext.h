//
//  ViewControllerContext.h
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/28.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ViewController.h"

//edit context
@interface ViewEditContext : NSObject<VMContext, UITextViewDelegate>
@property (nonatomic, weak) ViewController<VMDelegate> *delegate;
@property (nonatomic, strong) NSString *identify;
- (instancetype)initWithIdentify:(NSString *)identify;
@end

//list context
@interface ViewListContext : NSObject<VMContext, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) ViewController<VMDelegate> *delegate;
@property (nonatomic, strong) NSMutableArray<NSString *> *dataSource;
@end
