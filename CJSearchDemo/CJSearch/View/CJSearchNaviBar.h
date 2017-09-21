//
//  CJSearchNaviBar.h
//  CJSearchDemo
//
//  Created by 创建zzh on 2017/9/20.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchBarShouldBeginEditingBlock)(UISearchBar *searchBar);

typedef void(^SearchBarSearchButtonClickedBlock)(UISearchBar *searchBar);

@interface CJSearchNaviBar : UIView

/**
 * 初始化
 * 开始输入（弹出输入框，显示历史记录 和 热门搜索）
 * 点击搜索 (回调到控制器进行操作)
 */
- (instancetype)initWithFrame:(CGRect)frame
               beginEditBlock:(SearchBarShouldBeginEditingBlock)editBlock
             clickSearchBlock:(SearchBarSearchButtonClickedBlock)searchBlock;

@property (nonatomic, copy)SearchBarShouldBeginEditingBlock beginEditBlock;

@property (nonatomic, copy)SearchBarSearchButtonClickedBlock searchBlock;


//点击取消按钮
@property (nonatomic, copy)dispatch_block_t clickCancelBlock;

//联想搜索开启
@property (nonatomic, copy)void(^tfdDidChangedBlock)(NSString *key);
//开启联想搜索
@property (nonatomic, assign)BOOL openAssociativeSearch;

//输入框
@property (nonatomic, strong) UISearchBar *searchBar;



@end
