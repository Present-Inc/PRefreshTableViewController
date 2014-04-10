//
//  PTableViewController.m
//  PTableViewController
//
//  Created by Justin Makaila on 3/10/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import "PRefreshTableViewController.h"

@interface PRefreshTableViewController () <PRefreshControlDelegate>

@property (nonatomic, getter = isRefreshing) BOOL refreshing;
@property (nonatomic, getter = isInitialized) BOOL initialized;

- (void)setIdleState;
- (void)setInitializingState;
- (void)setRefreshingHeaderState;
- (void)setLoadingFooterState;
- (void)setEmptyState;

@end

@implementation PRefreshTableViewController

#pragma mark - Lifecycle
#pragma mark Dealloc

- (void)dealloc {
    self.delegate = nil;
}

#pragma mark Init

- (id)init {
    self = [super init];
    if (self) {
        [self baseInit];
    }
    
    return self;
}

- (void)awakeFromNib {
    [self baseInit];
}

- (void)baseInit {
    _delegate = self;
    _items = [NSMutableArray array];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    NSLog((@"%s [Line %d]"), __PRETTY_FUNCTION__, __LINE__);
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    if ([_delegate respondsToSelector:@selector(observeModel)]) {
        [_delegate observeModel];
    }
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupTableView];
    [self setupData];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.refreshing = NO;
    
    [self.refreshControl endRefreshing];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    NSLog((@"%s [Line %d]"), __PRETTY_FUNCTION__, __LINE__);
    
    self.refreshControl = [PRefreshControl attachToTableView:self.tableView
                                                    position:PRefreshControlPositionHeader
                                                      target:self
                                                      action:@selector(refreshTriggered)];
    self.refreshControl.delegate = self;
    
    if (!self.initializeView && !self.isInitialized) {
        self.initializeView = [[PInitializeView alloc] initWithFrame:self.tableView.frame];
        [self.view insertSubview:self.initializeView belowSubview:self.tableView];
    }
    
    [self.view layoutSubviews];
    [super viewDidLayoutSubviews];
}

#pragma mark - Setup

- (void)setupTableView {
    if (!self.tableViewDataSource) {
        self.tableViewDataSource = [[PDataSource alloc] initWithItems:self.items];
    }
    
    if (!self.tableViewDataSource.delegate) {
        self.tableViewDataSource.delegate = self;
    }
    
    if (!self.tableView.dataSource) {
        self.tableView.dataSource = self.tableViewDataSource;
    }
    
    if (!self.tableView.delegate) {
        self.tableView.delegate = self.tableViewDataSource;
    }
}

- (void)setupData {
    if (self.items.count == 0) {
        if (!self.isInitialized) {
            self.tableViewState = PTableViewControllerStateInitializing;
        }
        
        [self beginRefreshing];
    }else {
        [self endRefreshing];
        [self reloadTableView];
    }
}

#pragma mark - State Management

- (void)reloadTableView {
    [self.tableView reloadData];
}

- (void)setInitialized:(BOOL)initialized {
    _initialized = initialized;
}

- (void)setTableViewState:(PTableViewControllerState)tableViewState {
    if ([_delegate respondsToSelector:@selector(tableViewController:willTransitionToState:)]) {
        [_delegate tableViewController:self willTransitionToState:tableViewState];
    }
    
    _tableViewState = tableViewState;
    
    switch (_tableViewState) {
        case PTableViewControllerStateIdle:
            [self setIdleState];
            break;
        case PTableViewControllerStateInitializing:
            [self setInitializingState];
            break;
        case PTableViewControllerStateRefreshingHeader:
            [self setRefreshingHeaderState];
            break;
        case PTableViewControllerStateLoadingFooter:
            [self setLoadingFooterState];
            break;
        case PTableViewControllerStateEmpty:
            [self setEmptyState];
            break;
        default:
            break;
    }
}

- (void)setIdleState {
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    
    self.tableView.separatorStyle = separatorStyle;
    self.initializeView.hidden = YES;
}

- (void)setInitializingState {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.initializeView.hidden = NO;
}

- (void)setRefreshingHeaderState {
    NSLog(@"This is the refreshing header state");
}

- (void)setLoadingFooterState {
    [self showFooterView];
}

- (void)setEmptyState {
    self.initializeView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)showFooterView {
    if (!self.tableView.tableFooterView) {
        self.tableView.tableFooterView = [[[UINib nibWithNibName:@"PRefreshFooterView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    }
}

- (void)hideFooterView {
    self.tableView.tableFooterView = nil;
}

#pragma mark - PRefreshControl Delegate

- (BOOL)shouldBeginRefresh {
    return self.canBeginRefresh;
}

#pragma mark - PDataSource Delegate

- (NSInteger)loadMoreIndex {
    return 3;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.refreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.refreshControl scrollViewDidEndDragging];
}

#pragma mark - Refresh
#pragma mark PTableViewController Delegate

- (BOOL)canBeginRefresh {
    NSAssert(NO, @"-canBeginRefresh is intended to be implemented by subclasses");
    return NO;
}

- (BOOL)isTableViewEmpty {
    NSAssert(NO, @"-isTableViewEmpty is intended to be implemented by subclasses");
    return YES;
}

- (BOOL)isNetworkReachable {
    NSAssert(NO, @"-isNetworkReachable is intended to be implemented by subclasses");
    return NO;
}

- (void)resetCursor {
    self.cursor = 0;
}

- (void)refreshBlock {
    NSAssert(NO, @"-refreshBlock is intended to be implemented by subclasses");
}

- (void)endRefreshingWithResults:(NSArray *)results {
    NSAssert(NO, @"-endRefreshingWithResults: is intended to be implemented by subclasses");
}

- (void)endRefreshingWithError:(NSError *)error {
    NSAssert(NO, @"-endRefreshingWithError: is intended to be implemented by subclasses");
}

#pragma mark Flow
                           
- (void)refreshTriggered {
    [self beginRefreshing];
}

- (void)beginRefreshing {
    [self resetCursor];
    [self loadMore];
}

- (void)loadMore {
    if (!self.canBeginRefresh) {
        return;
    }
    
    if (self.cursor > 0) {
        self.tableViewState = PTableViewControllerStateLoadingFooter;
        [self showFooterView];
    }
    
    self.refreshing = YES;
    [_delegate refreshBlock];
}

- (void)endRefreshing {
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    
    if (self.tableView.tableFooterView) {
        [self hideFooterView];
    }
    
    if (!self.isInitialized) {
        self.initialized = YES;
    }
    
    self.refreshing = NO;
    self.tableViewState = (self.items.count == 0) ? PTableViewControllerStateEmpty : PTableViewControllerStateIdle;
}

@end
