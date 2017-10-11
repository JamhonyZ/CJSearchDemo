//
//  CJSearchTbView.m
//  CJSearchDemo
//
//  Created by 创建zzh on 2017/9/20.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import "CJSearchTbView.h"
#import "common_define.h"

@interface CJSearchTbView ()
<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CJSearchTbView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return self;
}

#pragma mark -- delegate
#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.sourceData.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier0 = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier0];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier0];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = UIColorHex(0x646464);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        NSString *imageName = [_type isEqualToString:@"0"] ? @"search_history_icon":@"xj_alert_succeed";
        cell.imageView.image = [UIImage imageNamed:imageName];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = UIColorHex(0x282828);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.sourceData[indexPath.row];
    return cell;
 
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_type isEqualToString:@"0"]) {
        
        NSString *keyword = nil;
        
        keyword = self.sourceData[indexPath.row];
        //
        
        self.userInteractionEnabled = NO;
        
        
        if (self.clickResultBlock) {
            self.clickResultBlock(keyword);
            
        }

    } else if ([_type isEqualToString:@"1"]) {
        NSLog(@"点击了----:%@",self.sourceData[indexPath.row]);
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)setType:(NSString *)type {
    _type = type;
}
#pragma mark -- groupHeadView
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([self.type isEqualToString:@"0"]) {
        
        NSArray *originData = [[NSUserDefaults standardUserDefaults] objectForKey:kHistroySearchData];
        if (originData.count == 0) return nil;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTagTitleHeight+10)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTagTitleHeight)];
        tipLabel.text = @"   历史搜索";
        tipLabel.backgroundColor = [UIColor whiteColor];
        tipLabel.textColor = UIColorHex(0x646464);
        tipLabel.font = [UIFont boldSystemFontOfSize:15];
        [view addSubview:tipLabel];

        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(SCREEN_WIDTH-30, 0, 20, 20);
        [deleteBtn setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
        deleteBtn.contentMode = UIViewContentModeCenter;
        [view addSubview:deleteBtn];
        [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    }
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray *originData = [[NSUserDefaults standardUserDefaults] objectForKey:kHistroySearchData];
    return [self.type isEqualToString:@"0"] ? (originData.count == 0 ? 0.01 : 30.f) : 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark -- Action
- (void)deleteAction {
    if (self.clickDeleteBlock) {
        self.clickDeleteBlock();
    }
}
#pragma mark -- LazyLoad
- (NSMutableArray *)sourceData {
    if (!_sourceData) {
        _sourceData = @[].mutableCopy;
    }
    return _sourceData;
}

@end
