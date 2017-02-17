//
//  CSContact.h
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSContact : NSObject

@property (nonatomic) NSString * fullname;
@property (nonatomic) NSString * shortName;
@property (nonatomic) UIImage * avatar;
@property (nonatomic) NSArray<NSString *> * phoneNumbers;
@property (nonatomic) NSArray<NSString *> * emails;

@end
