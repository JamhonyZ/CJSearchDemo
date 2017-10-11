//
//  CJSearchVC.m
//  CJSearchDemo
//
//  Created by 创建zzh on 2017/9/18.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import "CJSearchVC.h"
#import "common_define.h"
#import "CJSearchHotView.h"
#import "CJSearchTbView.h"
#import "CJSearchNaviBar.h"
#import "common_define.h"

typedef NS_ENUM(NSUInteger, ViewDisplayType) {
    ViewDisplayHistoryTableViewType,     //显示历史搜索
    ViewDisplayResultViewType,           //显示结果
    ViewDisplayDataBlankType             //数据为空
};

@interface CJSearchVC ()

@property (nonatomic, strong) CJSearchNaviBar *navigationBar;

@property (nonatomic, strong) CJSearchTbView *historyTBView;

@property (nonatomic, strong) CJSearchTbView *resultTBView;

@property (nonatomic, strong) NSMutableArray *historyData;

@property (nonatomic, strong) NSMutableArray *resultData;

@property (nonatomic, assign) ViewDisplayType viewDisplayType;

@property (nonatomic, strong) CJSearchHotView *hotHeadView;

@end

@implementation CJSearchVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatView];
}

- (void)creatView {

    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.historyTBView];
    [self.view addSubview:self.resultTBView];
    
    [self.navigationBar.searchBar becomeFirstResponder];
    
    //加载历史
    [self loadSearchHistoryData];
}


#pragma mark -- Action
- (void)backToSuperView {
    [self.navigationBar.searchBar resignFirstResponder];
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -- Data
- (void)loadResultData:(NSString *)key {
    
    self.viewDisplayType = ViewDisplayResultViewType;

    /*****模拟请求*******/
    [self.resultData removeAllObjects];
    
    for (int i = 0; i<10; i++) {
        
        [self.resultData addObject:[NSString stringWithFormat:@"搜索结果%@%@",key,@(i)]];
    }
    
    self.resultTBView.userInteractionEnabled = YES;
    
    [self.resultTBView.sourceData removeAllObjects];
    [self.resultTBView.sourceData addObjectsFromArray:self.resultData];
    [self.resultTBView reloadData];
    
    if (!self.navigationBar.openAssociativeSearch) {
        [self.navigationBar.searchBar resignFirstResponder];
    }
}


//点击清除按钮 || 呼出键盘
- (void)stopSearchAction
{
    self.viewDisplayType = ViewDisplayHistoryTableViewType;
    [self.historyTBView.sourceData removeAllObjects];
    [self.historyTBView.sourceData addObjectsFromArray:self.historyData];
    [self.historyTBView reloadData];
    
}

/**
 切换显示的view
 */
- (void)setViewDisplayType:(ViewDisplayType)viewDisplayType
{
    _viewDisplayType = viewDisplayType;
    switch (viewDisplayType) {
        case ViewDisplayHistoryTableViewType:
            //显示历史搜索
            self.resultTBView.hidden = YES;
            self.historyTBView.hidden = NO;
            [self.view bringSubviewToFront:self.historyTBView];
            self.historyTBView.userInteractionEnabled = YES;
            break;
        case ViewDisplayResultViewType:
            //显示搜索结果
            self.historyTBView.hidden = YES;
            self.resultTBView.hidden = NO;
            [self.view bringSubviewToFront:self.resultTBView];
            break;
        default:
            break;
    }
}
#pragma mark 本地搜索历史记录
/**
 *  本地搜索历史记录
 */
- (void)loadSearchHistoryData
{
    NSArray *originData = [[NSUserDefaults standardUserDefaults] objectForKey:kHistroySearchData];
    
    if (originData.count > 0) {
        [self.historyData addObjectsFromArray:originData];
    }
    [self.historyTBView.sourceData removeAllObjects];
    [self.historyTBView.sourceData addObjectsFromArray:self.historyData];
    [self.historyTBView reloadData];
    self.viewDisplayType = ViewDisplayHistoryTableViewType;
}
/**
 *  保存搜索记录
 */
- (void)saveHistoryKeyWord:(NSString *)keyword
{
    NSString *searchKey = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
    if ([searchKey length] == 0) return;
    
    if ([self.historyData containsObject:searchKey]) {
        //如果之前存在，则排序置顶
        [self.historyData removeObject:searchKey];
        [self.historyData insertObject:searchKey atIndex:0];
    } else {
        //如果之前不存在，则插入置顶
        [self.historyData insertObject:searchKey atIndex:0];
    }
    
    //保存最大数量
    if (self.historyData.count > kMaxHistroyNum) {
        [self.historyData removeLastObject];
    }

    [[NSUserDefaults standardUserDefaults] setObject:self.historyData forKey:kHistroySearchData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.historyTBView.sourceData removeAllObjects];
    [self.historyTBView.sourceData addObjectsFromArray:self.historyData];
    [self.historyTBView reloadData];
    
    self.resultTBView.userInteractionEnabled = NO;
    
    self.navigationBar.searchBar.text = keyword;
    [self loadResultData:keyword];
}
/**
 *  清除搜索记录
 */
- (void)deleteHistoryData
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:deleteTip message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.historyData removeAllObjects];

        [[NSUserDefaults standardUserDefaults] setObject:self.historyData forKey:kHistroySearchData];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.historyTBView.sourceData removeAllObjects];
        [self.historyTBView.sourceData addObjectsFromArray:self.historyData];
        [self.historyTBView reloadData];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

#pragma mark - LazyLoad
/**
 自定义的导航栏
 */
- (CJSearchNaviBar *)navigationBar
{
    if (!_navigationBar) {
        __weak typeof(self) weakSelf = self;
        _navigationBar = [[CJSearchNaviBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CJ_StatusBarAndNavigationBarHeight) beginEditBlock:^(UISearchBar *searchBar) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf stopSearchAction];
        } clickSearchBlock:^(UISearchBar *searchBar) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf saveHistoryKeyWord:searchBar.text];
        }];
        _navigationBar.backgroundColor = [UIColor whiteColor];
        _navigationBar.clickCancelBlock = ^(){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf backToSuperView];
        };
        //开启联想搜索
//        _navigationBar.tfdDidChangedBlock = ^(NSString *key) {
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            if (![key isEqualToString:@""]) {                
//                [strongSelf loadResultData:key];
//            } else {
//                [strongSelf stopSearchAction];
//            }
//        };
    }
    return _navigationBar;
}
//历史搜索列表
- (CJSearchTbView *)historyTBView
{
    if (!_historyTBView) {
        _historyTBView = [[CJSearchTbView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CJ_StatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
        _historyTBView.type = @"0";
        _historyTBView.backgroundColor = [UIColor whiteColor];
        _historyTBView.separatorColor = UIColorHex(0xf0f0f0);
        _historyTBView.rowHeight = 44;
        _historyTBView.tableHeaderView = self.hotHeadView;
        __weak typeof(self) weakSelf = self;
        _historyTBView.clickResultBlock = ^(NSString *key){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.navigationBar.searchBar.text = key;
            [strongSelf loadResultData:key];
        };

        _historyTBView.clickDeleteBlock = ^(){
            __strong typeof(weakSelf)  strongSelf = weakSelf;
            [strongSelf deleteHistoryData];
        };
    }
    
    return _historyTBView;
}
//搜索结果列表
- (CJSearchTbView *)resultTBView {
    if (!_resultTBView) {
        _resultTBView = [[CJSearchTbView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CJ_StatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _resultTBView.backgroundColor = [UIColor whiteColor];
        _resultTBView.separatorColor = UIColorHex(0xf0f0f0);
        _resultTBView.type = @"1";
        _resultTBView.rowHeight = 50;
        
    }
    return _resultTBView;
}
//历史搜索数据源
- (NSMutableArray *)historyData
{
    if (!_historyData) {
        _historyData = @[].mutableCopy;
    }
    return _historyData;
}
//搜索结果数据源
- (NSMutableArray *)resultData {
    if (!_resultData) {
        _resultData = @[].mutableCopy;
    }
    return _resultData;
}

//热门视图搜索
- (CJSearchHotView *)hotHeadView {
    if (!_hotHeadView) {
        __weak typeof(self) weakSelf = self;
        _hotHeadView = [[CJSearchHotView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) tagColor:kSearchBarTFDColor tagBlock:^(NSString *key) {
            NSLog(@"点击热搜%@",key);
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf saveHistoryKeyWord:key];
        }];
        _hotHeadView.hotKeyArr = @[@"我是",@"创建",@"科技",@"研发",@"iOS组员",@"玉树临风",@"高大威猛",@"才华横溢",@"这TM都信"];
    }
    return _hotHeadView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
