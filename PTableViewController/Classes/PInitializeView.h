//
//  PInitializeView.h
//  Present
//
//  Created by Justin Makaila on 2/24/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PRefreshControlProtocol.h"

@interface PInitializeView : UIView <PRefreshControlProtocol>

@property (strong, nonatomic) UIImageView *refreshIndicator;

@end
