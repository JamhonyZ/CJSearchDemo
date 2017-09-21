//
//  CJSearchHotView.m
//  CJSearchDemo
//
//  Created by 创建zzh on 2017/9/18.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import "CJSearchHotView.h"
#import "common_define.h"

@interface CJSearchHotView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)UILabel *lastTagLabel;

@end

@implementation CJSearchHotView

- (instancetype)initWithFrame:(CGRect)frame
                     tagColor:(UIColor *)tagColor
                     tagBlock:(ClickHotTagBlock)clickBlock {

    self = [super initWithFrame:frame];
    
    if (self) {
                
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        
        _tagColor = tagColor;
        
        _clickBlock = clickBlock;
        
    }
    return self;
}

- (void)setHotKeyArr:(NSArray *)hotKeyArr {
    
    _hotKeyArr = hotKeyArr;
    
    //移除所有标签
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    //如果没有文本
    if (_hotKeyArr.count == 0) {
        self.hidden = YES;
        return;
    }

    //热门搜索tipLabel
    self.hidden = NO;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kTagTitleHeight)];
    tipLabel.text = @"   热门搜索";
    tipLabel.backgroundColor = [UIColor whiteColor];
    tipLabel.textColor = UIColorHex(0x646464);
    tipLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:tipLabel];
    

    //复原布局
    _lastTagLabel = nil;
    
    for (int i = 0 ; i<_hotKeyArr.count ;i++) {
        
        NSString *textStr = _hotKeyArr[i];
        
        UILabel *tag = [UILabel new];
        
        tag.text = textStr;
        
        CGSize tagSize = [textStr sizeWithAttributes:@{NSFontAttributeName:kTagFont}];
        tagSize.width += kTitleHorizontal_space*2;
        tagSize.height += kTitleVertical_space*2;

        if (i == 0) {
            //第一条，不存在lastTagLabel
            tag.frame = CGRectMake(kTagScreen_margin, kTagTitleHeight+kTagVertical_margin, tagSize.width, tagSize.height);
        } else {
            
            if (CGRectGetMaxX(_lastTagLabel.frame)+
                kTagHorizontal_margin +
                tagSize.width  > self.bounds.size.width-kTagScreen_margin) {
                //换行
                tag.frame = CGRectMake(kTagScreen_margin, CGRectGetMaxY(_lastTagLabel.frame)+kTagVertical_margin, tagSize.width, tagSize.height);
            }
            else {
                // 同一行
                tag.frame = CGRectMake(CGRectGetMaxX(_lastTagLabel.frame)+kTagHorizontal_margin, CGRectGetMinY(_lastTagLabel.frame), tagSize.width, tagSize.height);
                
            }
        }

        //配置文本
        [self configLabel:tag];
        
        [self addSubview:tag];
        
        _lastTagLabel = tag;
        
        //最后一个tag的时候赋值高度
        if (i == _hotKeyArr.count-1) {
            CGRect tempFrame = self.frame;
            tempFrame.size.height = CGRectGetMaxY(_lastTagLabel.frame)+kTagVertical_margin;
            self.frame = tempFrame;
        }
    }
    

}
- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}
#pragma mark -- 文本属性设置
- (void)configLabel:(UILabel *)tag {
    
    
    tag.userInteractionEnabled = YES;
    
    if(_tagColor){
        //可以单一设置tag的颜色
        tag.backgroundColor = _tagColor;
    }else{
        //tag颜色默认白色
        tag.backgroundColor = [UIColor whiteColor];
    }
    tag.textAlignment = NSTextAlignmentCenter;
    tag.textColor = [UIColor whiteColor];
    tag.font = kTagFont;
    tag.layer.cornerRadius = 10.0;
    tag.layer.borderWidth = 1.0;
    tag.layer.borderColor = [[UIColor colorWithWhite:0.895 alpha:1.000] CGColor];
    tag.clipsToBounds = YES;
    
    //给文本添加点击
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSubTagView:)];
    tapOne.delegate = self;
    tapOne.numberOfTapsRequired = 1.0;
    [tag addGestureRecognizer:tapOne];
}

#pragma mark -- 点击文本
-(void)touchSubTagView:(UITapGestureRecognizer*)tapOne
{
    UILabel *tag = (UILabel *)tapOne.view;
    if (_clickBlock) {
        _clickBlock(tag.text);
    }
}


@end
