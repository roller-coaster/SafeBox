//
//  MyTableViewController.m
//  MiracleMessenger
//
//  Created by GZMLUser on 15-4-21.
//  Copyright (c) 2015年 GZMiracle. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyTableViewCell.h"

@interface MyTableViewController ()
{
    /** 是否添加kvo */
    BOOL isAddKVO;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_refreshFooter;
}
@end

@implementation MyTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.myStyle = style;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.myStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self addObserver:self forKeyPath:@"isInteractived" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    isAddKVO = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /** 若tableView为编辑状态，必须在销毁前将编辑状态取消，否则emptyDataSet框架会崩溃 */
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO];
    }
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    if (isAddKVO) {
        [self removeObserver:self forKeyPath:@"isInteractived"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isInteractived"]) {
        [self.tableView setScrollEnabled:!self.isInteractived];
    }
}

#pragma mark - 初始tableView
- (void)initTableView
{
    if (!self.myStyle) self.myStyle = UITableViewStylePlain;
    
    self.tableView = [[UITableView alloc] initWithFrame:CURRENT_APP_CONTENT_FRAME style:self.myStyle];
    
//    self.tableView.backgroundColor = [ThemeManager themeColorFromType:themeColorType_TableViewBackgroundColor];
//    self.tableView.separatorColor = [ThemeManager themeColorFromType:themeColorType_TableViewSeparatorColor];
    [self.view addSubview:self.tableView];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    /** 解决ios7中tableview每一行下面的线向右偏移的问题 */
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self setEmptyDataWithTableView:self.tableView emptyDataSetSource:self emptyDataSetDelegate:self];
}

#pragma mark - /** 初始化下拉、上拉刷新功能*/
- (void)initRefreshControlWithTableView:(UITableView *)tableView IsHeadRefresh:(BOOL)isHeadRefresh refreshingBlock:(void(^)(MJRefreshBaseView *refresher))block
{
    void(^refreshBlock)(MJRefreshBaseView *refresher) = [block copy];
    
    if (isHeadRefresh) { /** 初始下拉刷新*/
        _refreshHeader = [MJRefreshHeaderView header];
        _refreshHeader.scrollView = tableView;
        __unsafe_unretained __block MJRefreshHeaderView *refreshHeader = _refreshHeader;

        _refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                refreshBlock(refreshHeader);
            });
        };
    } else { /** 初始上拉刷新*/
        _refreshFooter = [MJRefreshFooterView footer];
        _refreshFooter.scrollView = tableView;
        __unsafe_unretained __block MJRefreshFooterView *refreshFooter = _refreshFooter;
        _refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                refreshBlock(refreshFooter);
            });
        };
    }
}
#pragma mark - /** 设置TableView为空状态下背景视图*/
- (void)setEmptyDataWithTableView:(UITableView *)tableView emptyDataSetSource:(id<DZNEmptyDataSetSource>)dataSource emptyDataSetDelegate:(id<DZNEmptyDataSetDelegate>)delegate
{
    tableView.emptyDataSetSource = dataSource;
    tableView.emptyDataSetDelegate = delegate;
}



#pragma mark - UISearch Display TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyTableViewCell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CellIdentifier owner:self options:nil]lastObject];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deselectRowAtIndexPath:indexPath];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath afterDelay:(NSTimeInterval)seconds
{
    __weak UITableView *tbView = _tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tbView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deselectRowAtIndexPath:indexPath afterDelay:1.0];
}

#pragma mark - UITableView Edit
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return FALSE;
}

#pragma mark - UITableView Footer
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kContactCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.style == UITableViewStylePlain) {
        return 0.1f;
    }else
        return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView.style == UITableViewStylePlain) {
        return 0.1f;
    }else
        return 10;
}


#pragma mark - DZNEmptyDataSetSource Methods

@end
