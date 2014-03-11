//
//  PTableViewControllerExample.m
//  PTableViewController
//
//  Created by Justin Makaila on 3/10/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import "PTableViewControllerExample.h"

@interface PTableViewControllerExample ()

@end

@implementation PTableViewControllerExample

- (void)viewDidLoad {
    self.title = @"PTableViewController Example";
    
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
                                                          xibName:@"TestCell"
                                           cellConfigurationBlock:^(UITableViewCell *cell, NSNumber *number) {
                                               cell.textLabel.text = [NSString stringWithFormat:@"Hey, %i!", number.integerValue];
                                           }];
    
    self.tableViewDataSource.heightConfigurationBlock = ^CGFloat (NSIndexPath *indexPath) {
        return 200;
    };
    
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

- (void)endRefreshingWithResults:(NSArray *)results {
    NSLog(@"Cursor = %@", self.cursor);
    if ([self.cursor isEqualToString:@""]) {
        [self.items removeAllObjects];
    }
    
    [self.items addObjectsFromArray:results];
    [self reloadTableView];
    [self endRefreshing];
}

- (void)refreshBlock {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self endRefreshingWithResults:@[@1, @2, @3, @4, @5, @6]];
        self.cursor = nil;
    });
}

@end
