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

@class PTableViewController;

@protocol PTableViewControllerProtocol <NSObject>
@required
/**
 *  Operation to be performed for a refresh/load more call.
 *  
 *  @discussion This is typically where requests to an API are made
 */
- (void)refreshBlock;

/**
 *  Indicates whether the network is reachable
 *
 *  @discussion This method allows for the reachability status 
 *  to be determined by the individual subclass. Standard procedure
 *  is to use a reachability manager (Apple's Reachability, or 
 *  AFNetworkingReachabilityManager) to decide what network is
 *  reachable.
 *
 *  @return YES if a network (WiFi, WWAN, etc) is reachable, else NO
 */
- (BOOL)isNetworkReachable;

/**
 *  Indicates whether a refresh action can happen.
 *
 *  @discussion This method should be utilized to check the
 *  network reachability status, if the server has more results,
 *  and whether or not the controller is already fetching results.
 *
 *  @return YES if a refresh should happen, else NO
 */
- (BOOL)canBeginRefresh;

/**
 *  Indicates if the table view is empty.
 *
 *  @discussion The table view may be considered empty if the
 *  items array is empty, however, there are instances while using
 *  multiple sections where you may not want the table view to appear
 *  in the initializing state, due to static content.
 *
 *  @return YES if the table view is considered empty, else NO
 */
- (BOOL)isTableViewEmpty;

/**
 *  Handles ending the refresh cycle with results
 *
 *  @discussion This is the alternative to calling -endRefreshing.
 *  It is the point where the results are added to items and the
 *  table view is updated to reflect these additions
 *
 *  @param results The results from a server or cache
 */
- (void)endRefreshingWithResults:(NSArray*)results;

@optional
- (void)observeModel;
- (void)tableViewController:(PTableViewController*)tableViewController willTransitionToState:(PTableViewControllerState)state;
- (void)resetCursor;

@end

@interface PTableViewController : UIViewController <PTableViewControllerProtocol, PDataSourceDelegate> {
    UITableViewCellSeparatorStyle separatorStyle;
}

@property (weak, nonatomic) id<PTableViewControllerProtocol> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) PTableViewControllerState tableViewState;

@property (strong, nonatomic) PDataSource *tableViewDataSource;

@property (strong, nonatomic) PInitializeView *initializeView;

@property (strong, nonatomic) PRefreshControl *refreshControl;

@property (strong, nonatomic) NSString *cursor;
@property (strong, nonatomic) NSMutableArray *items;

- (void)setupTableView;
- (void)setupData;

- (void)reloadTableView;

- (BOOL)isRefreshing;
- (BOOL)isInitialized;
- (void)setInitialized:(BOOL)initialized;

- (void)beginRefreshing;
- (void)loadMore;
- (void)endRefreshing;

@end
