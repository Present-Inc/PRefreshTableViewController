//
//  PArrayDataSource+TableHeaderView.h
//  Present
//
//  Created by Justin Makaila on 2/8/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import "PDataSource.h"

@interface PDataSource (TableHeaderView)

- (void)setTableHeaderNib:(UINib*)nib forTableView:(UITableView*)tableView;
- (void)setTableHeaderView:(UIView*)view forTableView:(UITableView*)tableView;

@end
