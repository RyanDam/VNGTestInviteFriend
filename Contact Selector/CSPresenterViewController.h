//
//  CSPresenterViewController.h
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactSelectorViewController.h"

@interface CSPresenterViewController : UINavigationController

@property (nonatomic, weak) id<CSViewControllerDataSource> dataSourceCS;
@property (nonatomic, weak) id<CSViewControllerDelegate> delegateCS;


/**
 Get presenter instance for present

 @return navigation controller wrapper for ContactSelectorViewController
 */
+ (instancetype)presenter;

- (void)notifyDatasetChanged;

@end
