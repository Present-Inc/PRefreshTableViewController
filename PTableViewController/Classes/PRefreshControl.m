//
//  PRefreshControl.m
//  PTableViewController
//
//  Created by Justin Makaila on 3/10/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import "PRefreshControl.h"
#import "UIImage+animatedGIF.h"

#define REFRESH_CONTROL_HEIGHT 71.0f
#define HEADER_POSITION_FRAME CGRectMake(0.0f, 0.0f, CGRectGetWidth(scrollView.bounds), 0.0f)
#define FOOTER_POSITION_FRAME CGRectMake(0.0f, scrollView.contentSize.height, CGRectGetWidth(scrollView.bounds), 0.0f)

typedef NS_ENUM(NSInteger, PRefreshControlState) {
    PRefreshControlStateHidden = 0,
    PRefreshControlStateRefreshing = 2
};

@interface PRefreshControl () {
    PRefreshControlState state;
    
    CGFloat originalInset;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic) SEL refreshAction;
@property (strong, nonatomic) id refreshTarget;

+ (instancetype)findExistingRefreshControlInView:(UIView*)view forPosition:(PRefreshControlPosition)position;

- (CGFloat)distanceScrolled;
- (BOOL)offsetShouldTriggerRefresh;

@end

@implementation PRefreshControl

+ (instancetype)attachToTableView:(UITableView *)tableView position:(PRefreshControlPosition)position target:(id)refreshTarget action:(SEL)refreshAction {
    return [self attachToScrollView:tableView position:position target:refreshTarget action:refreshAction];
}

+ (instancetype)attachToScrollView:(UIScrollView*)scrollView position:(PRefreshControlPosition)position target:(id)refreshTarget action:(SEL)refreshAction {
    PRefreshControl *refreshControl = [self findExistingRefreshControlInView:scrollView forPosition:position];
    if (refreshControl != nil) {
        return refreshControl;
    }
    
    CGRect frame = (position == PRefreshControlPositionHeader) ? HEADER_POSITION_FRAME : FOOTER_POSITION_FRAME;
    
    refreshControl = [[PRefreshControl alloc] initWithFrame:frame
                                                 scrollView:scrollView
                                                   position:position
                                                     target:refreshTarget
                                                     action:refreshAction];
    [scrollView addSubview:refreshControl];
    
    return refreshControl;
}

+ (instancetype)findExistingRefreshControlInView:(UIView *)view forPosition:(PRefreshControlPosition)position {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            PRefreshControl *control = (PRefreshControl*)subview;
            if (control->_position == position) {
                return control;
            }
        }
    }
    
    return nil;
}

- (id)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView position:(PRefreshControlPosition)position target:(id)refreshTarget action:(SEL)refreshAction {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        self.scrollView = scrollView;
        self.refreshTarget = refreshTarget;
        self.refreshAction = refreshAction;
        
        [self setupRefreshIndicator];
        
        _position = position;
        
        originalInset = (position == PRefreshControlPositionHeader) ? scrollView.contentInset.top : scrollView.contentSize.height;
    }
    
    return self;
}

- (void)setupRefreshIndicator {
    self.refreshIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 51, 51)];
    
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"loader-white" ofType:@"gif"];
    UIImage *refreshGif = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfFile:gifPath]];
    
    self.refreshIndicator.animationImages = refreshGif.images;
    self.refreshIndicator.animationDuration = refreshGif.duration;
    self.refreshIndicator.image = refreshGif.images.lastObject;
    self.refreshIndicator.alpha = 0.0f;
    self.refreshIndicator.center = self.center;
    
    [self addSubview:self.refreshIndicator];
}

#pragma mark - PRefreshControl Protocol

- (BOOL)isRefreshing {
    return (state == PRefreshControlStateRefreshing);
}

- (void)beginRefreshing {
    [self beginRefreshingAnimated:YES];
}

- (void)beginRefreshingAnimated:(BOOL)animated {
    if (state != PRefreshControlStateRefreshing) {
        state = PRefreshControlStateRefreshing;
        
        [self scrollRefreshControlToVisible:YES aniamted:animated];
        
        if (![self.refreshIndicator isAnimating]) {
            [self.refreshIndicator startAnimating];
        }
    }
}

- (void)endRefreshing {
    [self endRefreshingAnimated:YES];
}

- (void)endRefreshingAnimated:(BOOL)animated {
    if (state == PRefreshControlStateRefreshing) {
        [self scrollRefreshControlToVisible:NO aniamted:animated];
        
        if ([self.refreshIndicator isAnimating]) {
            [self.refreshIndicator stopAnimating];
        }
        
        self.refreshIndicator.alpha = 0.0f;
    }
}

#pragma mark - Scroll view
#pragma mark Utilities

- (CGFloat)distanceScrolled {
    CGFloat yOffset = self.scrollView.contentOffset.y;
    
    if (_position == PRefreshControlPositionHeader) {
        return yOffset + self.scrollView.contentInset.top;
    }else {
        return yOffset + CGRectGetHeight(self.scrollView.bounds);
    }
}

- (BOOL)offsetShouldTriggerRefresh {
    if (_position == PRefreshControlPositionHeader) {
        return (-self.distanceScrolled > REFRESH_CONTROL_HEIGHT);
    }else {
        return (self.distanceScrolled > (self.scrollView.contentSize.height + REFRESH_CONTROL_HEIGHT));
    }
}

- (void)scrollRefreshControlToVisible:(BOOL)visible aniamted:(BOOL)animated {
    CGFloat animationDuration = (animated) ? 0.25f : 0.0f;
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         UIEdgeInsets insets = self.scrollView.contentInset;
                         
                         if (_position == PRefreshControlPositionHeader) {
                             insets.top = (visible) ? originalInset + REFRESH_CONTROL_HEIGHT : originalInset;
                         }else {
                             insets.bottom = (visible) ? originalInset + REFRESH_CONTROL_HEIGHT : originalInset;
                         }
                         
                         self.scrollView.contentInset = insets;
                     }completion:^(BOOL success) {
                         if (success && !visible) {
                             state = PRefreshControlStateHidden;
                         }
                     }];
}

- (void)scrollViewDidScroll {
    CGFloat offset;
    if (_position == PRefreshControlPositionHeader) {
        offset = -self.distanceScrolled;
    }else {
        offset = self.distanceScrolled;
    }
    
    [self offsetRefreshControlBy:offset];
}

- (void)scrollViewDidEndDragging {
    if (state == PRefreshControlStateHidden) {
        if ([self offsetShouldTriggerRefresh]) {
            if (_position == PRefreshControlPositionFooter && ![_delegate shouldBeginRefresh]) {
                return;
            }
            
            [self beginRefreshing];
            [self triggerRefresh];
        }
    }
}

- (void)triggerRefresh {
    #pragma cland diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self.refreshTarget respondsToSelector:self.refreshAction]) {
        [self.refreshTarget performSelector:self.refreshAction];
    }
    #pragma clang diagnostic pop
}

- (void)offsetRefreshControlBy:(CGFloat)offset {
    if (_position == PRefreshControlPositionHeader) {
        [self offsetHeaderWithInitialOffset:offset];
    }else {
        [self offsetFooterWithInitialOffset:offset];
    }
}

- (void)offsetHeaderWithInitialOffset:(CGFloat)initialOffset {
    if (state != PRefreshControlStateHidden) {
        initialOffset += REFRESH_CONTROL_HEIGHT;
    }
    
    CGRect newFrame = self.frame;
    newFrame.size.height = initialOffset;
    newFrame.origin.y = -initialOffset;
    self.frame = newFrame;
    
    self.refreshIndicator.center = (CGPoint) { CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) };
    
    CGFloat indicatorAlpha = initialOffset / REFRESH_CONTROL_HEIGHT;
    if (indicatorAlpha < 1.0f && indicatorAlpha > 0.0f) {
        self.refreshIndicator.alpha = indicatorAlpha;
    }
}

- (void)offsetFooterWithInitialOffset:(CGFloat)initialOffset {
    CGFloat heightOffset = -(initialOffset - self.scrollView.contentSize.height);
    
    CGRect newFrame = self.frame;
    newFrame.size.height = heightOffset;
    newFrame.origin.y = initialOffset;
    self.frame = newFrame;
    
    self.refreshIndicator.center = (CGPoint) { CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) };
    
    CGFloat indicatorAlpha = -(heightOffset / REFRESH_CONTROL_HEIGHT);
    if (indicatorAlpha < 1.0f && indicatorAlpha > 0.0f) {
        self.refreshIndicator.alpha = indicatorAlpha;
    }
}

@end
