//
//  PDataSourceProtocol.h
//  Present
//
//  Created by Justin Makaila on 2/24/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PDataSourceDelegate <NSObject>

- (NSInteger)loadMoreIndex;

@optional

- (void)triggerLoadMore;

- (void)scrollViewDidScroll:(UIScrollView*)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)scrollViewDidScrollToTop;

@end
