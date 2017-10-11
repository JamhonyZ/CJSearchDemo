//
//  common_define.h
//  CJSearchDemo
//
//  Created by 创建zzh on 2017/9/18.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#ifndef common_define_h
#define common_define_h

//
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

//搜索框颜色
#define kSearchBarTFDColor UIColorHex(0x00B38A)
//文字颜色
#define kMainTextColor UIColorHex(0x646464)

#define UIColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


/** 字体离边框的水平距离 */
#define kTitleHorizontal_space 10.0f

/** 字体离边框的竖直距离 */
#define kTitleVertical_space   5.0f

/** tagLab之间的水平间距 */
#define kTagHorizontal_margin  15.0f

/** tagLab之间的竖直间距 */
#define kTagVertical_margin    10.0f

/** tagLab与屏幕左右间距 */
#define kTagScreen_margin  12.f

/** tag字体 **/
#define kTagFont [UIFont boldSystemFontOfSize:13]

//标题高度
static CGFloat const kTagTitleHeight = 20.f;

//清除tip文本
static NSString *const deleteTip = @"您要清除搜索记录么？";

//key
static NSString *const kHistroySearchData = @"HistroySearchData";

//最大历史搜索条数
static NSInteger const kMaxHistroyNum = 10;


#endif /* common_define_h */
