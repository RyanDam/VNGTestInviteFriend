//
//  OutgoingCallViewController.h
//  Contact Selector
//
//  Created by CPU11808 on 3/7/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSModel.h"

@interface OutgoingCallViewController : UIViewController

+ (instancetype)viewController;

@property (strong, nonatomic) NSString *callNumber;

@property (weak, nonatomic) CSModel *contact;

@end
