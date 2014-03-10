//
//  PDetailViewController.h
//  PTableViewController
//
//  Created by Justin Makaila on 3/10/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
