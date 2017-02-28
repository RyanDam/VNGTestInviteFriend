//
//  CallManagement.h
//  Contact Selector
//
//  Created by CPU11815 on 2/28/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallManagement : NSObject

+ (instancetype)management;

- (void)makePhoneCall:(NSString *)phone;

- (void)makeMessage:(NSString *)phone;

@end
