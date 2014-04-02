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
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.cursor = @"";
    [super viewDidAppear:animated];
}

- (void)setupTableView {
    self.tableViewDataSource = [[PDataSource alloc] initWithItems:self.items
                                                   cellIdentifier:@"Cell"
                                                          xibName:@"TestCell"];
    
    __block typeof(self) strongSelf = self;
    self.tableViewDataSource.configurationBlock = ^(UITableViewCell *cell, NSNumber *number, NSIndexPath *indexPath) {
        if (indexPath.row < strongSelf.items.count) {
            cell.textLabel.text = [NSString stringWithFormat:@"Hey, %li!", (long)number.integerValue];
        }else {
            NSLog(@"Show reload cell!");
            cell.textLabel.text = @"This is the load more cell!";
        }
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

/**
 *  Checks that the controller is not already refreshing,
 *  the network is reachable, and that the cursor is not nil
 *
 *  @return YES if all three are true, else NO
 */
- (BOOL)canBeginRefresh {
    return (!self.isRefreshing && self.isNetworkReachable && self.cursor);
}

- (BOOL)isTableViewEmpty {
    return NO;
}

- (void)resetCursor {
    self.cursor = @"";
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
    
    if ([self.cursor isEqualToString:@""]) {
        [self.tableView reloadData];
    }else {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self endRefreshing];
}

- (void)refreshBlock {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        // !!!: This should be a response from the API
        NSArray *results = @[@1, @2, @3, @4, @5, @6];
        
        if ([self.cursor isEqualToString:@""]) {
            [self.items removeAllObjects];
        }
        
        [self.items addObjectsFromArray:results];
        
        [self endRefreshingWithResults:results];

        if (loadMoreCount == 3) {
            self.cursor = nil;
        }else {
            self.cursor = @"someStringRepresentingACursor";
        }
    });
}

#pragma mark - PExampleDataSource Delegate

- (void)triggerLoadMore {
    if (loadMoreCount < 3) {
        loadMoreCount++;
    }
    
    [self loadMore];
}

@end
