//
//  ArrayDataSource.m
//  Present
//
//  Created by Justin Makaila on 1/15/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import "PDataSource.h"

@implementation PDataSource

- (id)initWithItems:(NSMutableArray *)items {
    return [self initWithItems:items cellIdentifier:nil xibName:nil cellConfigurationBlock:nil];
}

- (id)initWithItems:(NSMutableArray *)items cellIdentifier:(NSString *)identifier xibName:(NSString *)xibName {
    return [self initWithItems:items cellIdentifier:identifier xibName:xibName cellConfigurationBlock:nil];
}

- (id)initWithItems:(NSMutableArray*)items cellIdentifier:(NSString*)identifier xibName:(NSString*)xibName cellConfigurationBlock:(TableCellModelConfigurationBlock)configurationBlock {
    self = [super init];
    if (self) {
        _items = items;
        _cellIdentifier = identifier;
        _cellXibIdentifier = xibName;
        _configurationBlock = configurationBlock;
    }
    
    return self;
}

#pragma mark - Item Accessors

- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    return self.items[((NSUInteger)indexPath.row)];
}

- (id)itemAtIndex:(NSUInteger)index {
    return self.items[(NSUInteger)index];
}

- (NSString*)cellXibIdentifier {
    if (!_cellXibIdentifier) {
        _cellXibIdentifier = _cellIdentifier;
    }
    
    return _cellXibIdentifier;
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(indexPath.section == 0, @"More than one section");
    NSAssert(self.cellIdentifier != nil, @"A cell identifier is needed to use PTableViewController");
    
    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if (!cell) {
        cell = [[[UINib nibWithNibName:self.cellXibIdentifier bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    }
    
    id item = [self itemAtIndexPath:indexPath];
    
    !self.configurationBlock ?: self.configurationBlock(cell, item, indexPath);

    ((UITableViewCell*)cell).tag = indexPath.row;
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.heightConfigurationBlock ? self.heightConfigurationBlock(indexPath) : 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    !self.selectedIndexPathBlock ?: self.selectedIndexPathBlock(indexPath);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == (self.items.count - _delegate.loadMoreIndex)) {
        [self.delegate triggerLoadMore];
    }
}

#pragma mark UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([_delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([_delegate respondsToSelector:@selector(scrollViewDidScrollToTop)]) {
        [_delegate scrollViewDidScrollToTop];
    }
}

@end
