//
//  PRefreshCell.m
//  Pods
//
//  Created by Justin Makaila on 4/1/14.
//
//

#import "PRefreshFooterView.h"
#import "UIImage+animatedGIF.h"

@implementation PRefreshFooterView

- (id)init {
    self = [super init];
    if (self) {
        [self baseInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    
    return self;
}

- (void)awakeFromNib {
    [self baseInit];
}

- (void)baseInit {
    if (!self.refreshIndicator) {
        self.refreshIndicator = [[UIImageView alloc] init];
    }
    
    [self setupGif];
}

- (void)setupGif {
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"loader-white" ofType:@"gif"];
    UIImage *refreshGif = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfFile:gifPath]];
    
    self.refreshIndicator.animationImages = refreshGif.images;
    self.refreshIndicator.animationDuration = refreshGif.duration;
    self.refreshIndicator.image = refreshGif.images.lastObject;
    [self.refreshIndicator startAnimating];
}

- (void)layoutSubviews {
    self.refreshIndicator.center = self.center;
    
    [super layoutSubviews];
}

@end
