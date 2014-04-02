//
//  PRefreshControl.h
//  PTableViewController
//
//  Created by Justin Makaila on 3/10/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PRefreshControlProtocol.h"

typedef NS_ENUM(NSInteger, PRefreshControlPosition) {
    PRefreshControlPositionHeader = 0, /**< Position the refresh control as the scroll view header **/
    PRefreshControlPositionFooter = 1  /**< Position the refresh control as the scroll view footer **/
};

@protocol PRefreshControlDelegate <NSObject>
@required

/**
 *  Asks the delegate if a refresh should begin
 *
 *  @return YES if a refresh should begin, else NO
 */
- (BOOL)shouldBeginRefresh;
@end

@interface PRefreshControl : UIView <PRefreshControlProtocol> {
    PRefreshControlPosition _position;
}

@property (weak, nonatomic) id<PRefreshControlDelegate> delegate;

@property (strong, nonatomic) UIImageView *refreshIndicator;

+ (instancetype)attachToTableView:(UITableView*)tableView position:(PRefreshControlPosition)position target:(id)refreshTarget action:(SEL)refreshAction;
+ (instancetype)attachToScrollView:(UIScrollView*)scrollView position:(PRefreshControlPosition)position target:(id)refreshTarget action:(SEL)refreshAction;

- (id)initWithFrame:(CGRect)frame scrollView:(UIScrollView*)scrollView position:(PRefreshControlPosition)position target:(id)refreshTarget action:(SEL)refreshAction;

- (void)scrollRefreshControlToVisible:(BOOL)visible animated:(BOOL)animated completionHandler:(void(^)())completion;

- (void)scrollViewDidScroll;
- (void)scrollViewDidEndDragging;

@end
