//
//  AddBlockPhoneViewController.h
//  Contact Selector
//
//  Created by CPU11815 on 2/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSContact;
@class BlockPhoneViewController;

@protocol BlockPhoneViewControllerDelegate <NSObject>

- (void)addBlockPhoneViewController:(BlockPhoneViewController *)vc didAddModel:(CSContact *)model;

@end

@interface BlockPhoneViewController : UIViewController

@property (nonatomic, weak) id<BlockPhoneViewControllerDelegate> delegate;

+ (instancetype)viewController;

@end
