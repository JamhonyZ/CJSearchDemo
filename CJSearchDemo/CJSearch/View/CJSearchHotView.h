//
//  CJSearchHotView.h
//  CJSearchDemo
//
//  Created by 创建zzh on 2017/9/18.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickHotTagBlock)(NSString *key);


@interface CJSearchHotView : UIView


- (instancetype)initWithFrame:(CGRect)frame
                     tagColor:(UIColor *)tagColor
                     tagBlock:(ClickHotTagBlock)clickBlock;


/**
 *  整个View的背景颜色
 */
@property (nonatomic, strong) UIColor *bgColor;
/**
 *  设置子标签View的单一颜色
 */
@property (nonatomic, strong) UIColor *tagColor;

/**
 * 热门数组
 */
@property (nonatomic, strong)NSArray *hotKeyArr;

/**
 * 点击标签
 */
@property (nonatomic, copy)ClickHotTagBlock clickBlock;

@end
