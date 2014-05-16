//
//  PInitializeView.m
//  Present
//
//  Created by Justin Makaila on 2/24/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import "PInitializeView.h"

#import "UIImage+animatedGIF.h"

@interface PInitializeView ()

@property (nonatomic, getter = isRefreshing) BOOL refreshing;

@end

@implementation PInitializeView

- (id)init {
    self = [super init];
    if (self) {
        [self baseInit];
    }
    
    return  self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    
    return  self;
}

- (void)awakeFromNib {
    [self baseInit];
    [super awakeFromNib];
}

- (void)baseInit {
    self.backgroundColor = [UIColor clearColor];
    self.refreshIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 51, 51)];
    [self addSubview:_refreshIndicator];
    self.refreshIndicator.alpha = 1.0f;
    
    [self setupGif];
}

- (void)layoutSubviews {
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);
    
    self.refreshIndicator.center = CGPointMake(centerX, centerY);
    [super layoutSubviews];
}

- (void)setupGif {
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"loader-white" ofType:@"gif"];
    UIImage *refreshGif = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfFile:gifPath]];
    
    self.refreshIndicator.animationImages = refreshGif.images;
    self.refreshIndicator.animationDuration = refreshGif.duration;
    self.refreshIndicator.image = refreshGif.images.lastObject;
    [self.refreshIndicator startAnimating];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    
    if (hidden) {
        [self.refreshIndicator stopAnimating];
    }else {
        [self.refreshIndicator startAnimating];
    }
}

- (void)beginRefreshing {
    [self beginRefreshingAnimated:YES];
}

- (void)beginRefreshingAnimated:(BOOL)animated {
    [self.refreshIndicator startAnimating];
    _refreshing = YES;
}

- (void)endRefreshing {
    [self endRefreshingAnimated:YES];
}

- (void)endRefreshingAnimated:(BOOL)animated {
    [self.refreshIndicator stopAnimating];
    _refreshing = NO;
}

@end
