//
//  ArrayDataSource.h
//  Present
//
//  Created by Justin Makaila on 1/15/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PDataSourceDelegate.h"
#import "PRefreshFooterView.h"

typedef void (^TableCellConfigurationBlock) (id cell);
typedef void (^TableCellModelConfigurationBlock) (id cell, id item, NSIndexPath *indexPath);
typedef void (^TableCellIndexPathConfigurationBlock) (id cell, NSIndexPath *indexPath);

typedef CGFloat (^TableCellHeightForIndexPathBlock) (NSIndexPath *indexPath);

typedef void (^SelectedIndexPathBlock) (NSIndexPath *indexPath);

@interface PDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<PDataSourceDelegate> delegate;

/**
 *  The array to use as a data source
 */
@property (strong, nonatomic) NSArray *items;

/**
 *  The reuse identifier to use for a cell
 */
@property (copy, nonatomic) NSString *cellIdentifier;

/**
 *  The identifier of the cell's xib. Defaults to cell identifier
 */
@property (copy, nonatomic) NSString *cellXibIdentifier;

/**
 *  The block for configuring a cell with a model. Default does nothing
 */
@property (copy, nonatomic) TableCellModelConfigurationBlock configurationBlock;

/**
 *  A block to be used for configuring cell height. Defaults to 50
 */
@property (copy, nonatomic) TableCellHeightForIndexPathBlock heightConfigurationBlock;

/**
 *  A block to be called when an index path is selected. Default does nothing
 */
@property (copy, nonatomic) SelectedIndexPathBlock selectedIndexPathBlock;

- (id)initWithItems:(NSMutableArray*)items;
- (id)initWithItems:(NSMutableArray*)items cellIdentifier:(NSString*)identifier xibName:(NSString*)xibName;
- (id)initWithItems:(NSMutableArray*)items cellIdentifier:(NSString*)identifier xibName:(NSString*)xibName cellConfigurationBlock:(TableCellModelConfigurationBlock)configurationBlock;

- (id)itemAtIndexPath:(NSIndexPath*)indexPath;
- (id)itemAtIndex:(NSUInteger)index;

@end
