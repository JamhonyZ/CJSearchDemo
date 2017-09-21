//
//  CJSearchTbView.h
//  CJSearchDemo
//
//  Created by 创建zzh on 2017/9/20.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJSearchTbView : UITableView

// 数据源
@property (nonatomic, strong)NSMutableArray *sourceData;

// 0:历史 1:结果
@property (nonatomic, copy)NSString *type;

// 点击cell
@property (nonatomic, copy) void (^clickResultBlock)(NSString *key);

// 清除记录
@property (nonatomic, copy) void (^clickDeleteBlock)();

@end
