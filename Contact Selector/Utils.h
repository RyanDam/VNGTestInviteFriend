//
//  Utils.h
//  Contact Selector
//
//  Created by CPU11815 on 3/7/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (void)refreshCallDirectionBlockListWithCompletion:(void (^)(NSError * error))completion;

+ (void)showMessage:(NSString *)message inViewController:(UIViewController *)vc;

@end
