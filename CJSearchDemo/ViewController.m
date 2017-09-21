//
//  ViewController.m
//  CJSearchDemo
//
//  Created by 创建zzh on 2017/7/4.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import "ViewController.h"
#import "CJSearchVC.h"
#import "common_define.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake((SCREEN_WIDTH-100)/2, 100, 100, 30);
    [searchBtn setTitle:@"点击跳转" forState:UIControlStateNormal];
    [searchBtn setTitleColor:kMainTextColor forState:UIControlStateNormal];
    searchBtn.backgroundColor = kSearchBarTFDColor;
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBtn addTarget:self action:@selector(jumpAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
}
- (void)jumpAction {
    CJSearchVC *vc = [CJSearchVC new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
