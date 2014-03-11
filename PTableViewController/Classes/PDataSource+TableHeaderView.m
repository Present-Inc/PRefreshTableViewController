//
//  PArrayDataSource+TableHeaderView.m
//  Present
//
//  Created by Justin Makaila on 2/8/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import "PDataSource+TableHeaderView.h"

@implementation PDataSource (TableHeaderView)

- (void)setTableHeaderNib:(UINib *)nib forTableView:(UITableView *)tableView {
    UIView *view = [[nib instantiateWithOwner:nil options:nil] firstObject];
    [self setTableHeaderView:view forTableView:tableView];
}

- (void)setTableHeaderView:(UIView *)view forTableView:(UITableView *)tableView {
    tableView.tableHeaderView = view;
}

@end
