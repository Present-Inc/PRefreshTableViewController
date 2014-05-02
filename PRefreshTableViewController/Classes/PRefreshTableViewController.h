//
//  PTableViewController.h
//  PTableViewController
//
//  Created by Justin Makaila on 3/10/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PDataSource.h"
#import "PRefreshControl.h"
#import "PInitializeView.h"

typedef NS_ENUM(NSInteger, PTableViewControllerState) {
    PTableViewControllerStateIdle,
    PTableViewControllerStateInitializing,
    PTableViewControllerStateRefreshingHeader,
    PTableViewControllerStateLoadingFooter,
    PTableViewControllerStateEmpty
};

@class PRefreshTableViewController;

@protocol PRefreshTableViewControllerProtocol <NSObject>
@required
- (void)refreshBlock;

- (BOOL)isNetworkReachable;
- (BOOL)canBeginRefresh;
- (BOOL)isTableViewEmpty;

- (void)endRefreshingWithResults:(NSArray*)results;
- (void)endRefreshingWithError:(NSError *)error;

@optional
- (void)observeModel;
- (void)tableViewController:(PRefreshTableViewController*)tableViewController willTransitionToState:(PTableViewControllerState)state;
- (void)resetCursor;

@end

@interface PRefreshTableViewController : UIViewController <PRefreshTableViewControllerProtocol, PDataSourceDelegate> {
    UITableViewCellSeparatorStyle separatorStyle;
}

@property (weak, nonatomic) id<PRefreshTableViewControllerProtocol> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) PTableViewControllerState tableViewState;

@property (strong, nonatomic) PDataSource *tableViewDataSource;

@property (strong, nonatomic) PInitializeView *initializeView;

@property (strong, nonatomic) PRefreshControl *refreshControl;

@property (nonatomic) NSInteger cursor;
@property (strong, nonatomic) NSMutableArray *items;

- (void)setupTableView;
- (void)setupData;

- (void)reloadTableView;

- (BOOL)isRefreshing;
- (BOOL)isInitialized;

/**
 *  Sets the table view to the initializing state
 */
- (void)setInitializing;

- (void)beginRefreshing;
- (void)loadMore;
- (void)endRefreshing;

@end
