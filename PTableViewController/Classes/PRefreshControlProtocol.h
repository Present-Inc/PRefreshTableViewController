//
//  PRefreshViewProtocol.h
//  Present
//
//  Created by Justin Makaila on 2/24/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PRefreshControlProtocol <NSObject>

/**
 *  The refresh indicator
 */
@property (strong, nonatomic) UIImageView *refreshIndicator;

/**
 *  Indicates whether the view is refreshing or not
 *
 *  @return YES if refreshing, else NO
 */
- (BOOL)isRefreshing;

/**
 *  Begins refreshing the view
 */
- (void)beginRefreshing;

/**
 *  Begins refreshing the view programatically.
 *
 *  @param animated YES if the view should animate in, else NO
 */
- (void)beginRefreshingAnimated:(BOOL)animated;

/**
 *  Ends refreshing the view
 */
- (void)endRefreshing;

/**
 *  Ends refreshing the view programatically.
 *
 *  @param animated YES if the view should animate out, else NO
 */
- (void)endRefreshingAnimated:(BOOL)animated;

@end
