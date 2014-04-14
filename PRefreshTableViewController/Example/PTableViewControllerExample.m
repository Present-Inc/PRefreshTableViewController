//
//  PTableViewControllerExample.m
//  PTableViewController
//
//  Created by Justin Makaila on 3/10/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import "PTableViewControllerExample.h"

@interface PTableViewControllerExample () <PDataSourceDelegate> {
    NSInteger loadMoreCount;
}

// If you're subclassing PDataSource, it's property type must be overridden
// in this interface
@property (strong, nonatomic) PDataSource *tableViewDataSource;

@end

@implementation PTableViewControllerExample

- (void)viewDidLoad {
    self.title = @"PTableViewController Example";
    loadMoreCount = 0;
    
    [self setInitialized:NO];
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.cursor = 0;
    [super viewDidAppear:animated];
}

- (void)setupTableView {
    self.tableViewDataSource = [[PDataSource alloc] initWithItems:self.items
                                                   cellIdentifier:@"Cell"
                                                          xibName:@"TestCell"];
    
    self.tableViewDataSource.configurationBlock = ^(UITableViewCell *cell, NSNumber *number, NSIndexPath *indexPath) {
        cell.textLabel.text = [NSString stringWithFormat:@"Hey, %li!", (long)number.integerValue];
    };
    
    self.tableViewDataSource.heightConfigurationBlock = ^CGFloat (NSIndexPath *indexPath) {
        return 200;
    };
    
    self.tableViewDataSource.delegate = self;
    
    [super setupTableView];
}

- (BOOL)isNetworkReachable {
    return YES;
}

- (BOOL)canBeginRefresh {
    return (!self.isRefreshing && self.isNetworkReachable && self.cursor >= 0);
}

- (BOOL)isTableViewEmpty {
    return NO;
}

- (void)resetCursor {
    self.cursor = 0;
    loadMoreCount = 0;
}

- (void)endRefreshingWithResults:(NSArray *)results {
    NSInteger index = (self.items.count > 0) ? self.items.count - results.count : self.items.count;
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:results.count];
    NSInteger control = self.items.count;
    
    for (; index < control; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [indexPaths addObject:indexPath];
    }
    
    if (self.cursor == 0) {
        [self.tableView reloadData];
    }else {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self endRefreshing];
}

- (void)refreshBlock {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), self.refreshCompletionBlock);
}

#pragma mark - PExampleDataSource Delegate

- (void)triggerLoadMore {
    [self loadMore];
}

- (void(^)())refreshCompletionBlock {
    return ^(void) {
        // !!!: This should be a response from the API
        NSArray *results = @[@1, @2, @3, @4, @5, @6];
        
        if (self.cursor == 0) {
            [self.items removeAllObjects];
        }
        
        [self.items addObjectsFromArray:results];
        
        [self endRefreshingWithResults:results];
        
        loadMoreCount++;
        if (loadMoreCount == 3) {
            self.cursor = -1;
        }else {
            self.cursor = loadMoreCount;
        }
    };
}

@end
