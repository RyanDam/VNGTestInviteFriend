//
//  CSModel.h
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSModel : NSObject

@property (nonatomic) NSString * fullName;
@property (nonatomic) NSString * firstName;
@property (nonatomic) NSString * lastName;
@property (nonatomic) UIImage * avatar;

- (NSComparisonResult)compareTo:(CSModel *)other;

- (NSString *)shortName;

@end
