//
//  PTableViewController.m
//  PTableViewController
//
//  Created by Justin Makaila on 3/10/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import "PTableViewController.h"

@interface PTableViewController () <PRefreshControlDelegate>

@property (nonatomic, getter = isRefreshing) BOOL refreshing;
@property (nonatomic, getter = isInitialized) BOOL initialized;

- (void)setIdleState;
- (void)setInitializingState;
- (void)setRefreshingHeaderState;
- (void)setLoadingFooterState;
- (void)setEmptyState;

@end

@implementation PTableViewController

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
    _tableView.backgroundColor = [UIColor clearColor];
    [self setupTableView];
    
    if ([_delegate respondsToSelector:@selector(observeModel)]) {
        [_delegate observeModel];
    }
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupData];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.refreshing = NO;
    
    [self.refreshControl endRefreshing];
    [self.loadMoreControl endRefreshing];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    self.refreshControl = [PRefreshControl attachToTableView:self.tableView
                                                    position:PRefreshControlPositionHeader
                                                      target:self
                                                      action:@selector(refreshTriggered)];
    self.refreshControl.delegate = self;
    
    self.loadMoreControl = [PRefreshControl attachToTableView:self.tableView
                                                     position:PRefreshControlPositionFooter
                                                       target:self
                                                       action:@selector(loadMoreTriggered)];
    self.loadMoreControl.delegate = self;
    
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
    
    if (self.loadMoreControl.isRefreshing) {
        [self.loadMoreControl endRefreshing];
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
    NSLog(@"This is the loading footer state");
}

- (void)setEmptyState {
    self.initializeView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - PRefreshControl Delegate

- (BOOL)shouldBeginRefresh {
    NSLog(@"Can begin refresh? %@", self.canBeginRefresh ? @"YES" : @"NO");
    return self.canBeginRefresh;
}

#pragma mark - PDataSource Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.refreshControl scrollViewDidScroll];
    [self.loadMoreControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.refreshControl scrollViewDidEndDragging];
    
    if (scrollView.contentSize.height > CGRectGetHeight(scrollView.bounds)) {
        [self.loadMoreControl scrollViewDidEndDragging];
    }
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
    self.cursor = @"";
}

- (void)refreshBlock {
    NSAssert(NO, @"-refreshBlock is intended to be implemented by subclasses");
}

- (void)endRefreshingWithResults:(NSArray *)results {
    NSAssert(NO, @"-endRefreshingWithResults: is intended to be implemented by subclasses");
}

#pragma mark Flow
                           
- (void)refreshTriggered {
    NSLog(@"Refresh triggered");
    [self beginRefreshing];
}

- (void)loadMoreTriggered {
    NSLog(@"Load more triggered");
    [self loadMore];
}

- (void)beginRefreshing {
    [self resetCursor];
    [self loadMore];
}

- (void)loadMore {
    if (!self.canBeginRefresh) {
        return;
    }
    
    NSLog(@"Refreshing");
    
    self.refreshing = YES;
    [_delegate refreshBlock];
}

- (void)endRefreshing {
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    
    if (self.loadMoreControl.isRefreshing) {
        [self.loadMoreControl endRefreshing];
    }
    
    self.refreshing = NO;
    self.tableViewState = (self.items.count == 0) ? PTableViewControllerStateEmpty : PTableViewControllerStateIdle;
}

@end
