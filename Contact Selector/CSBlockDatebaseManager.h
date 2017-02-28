//
//  CSBlockDatebaseManager.h
//  Contact Selector
//
//  Created by Dam Vu Duy on 2/26/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSDatabaseManager.h"

@class CSContact;

@interface CSBlockDatebaseManager : CSDatabaseManager

+ (instancetype)manager;

- (NSArray<CSContact *> *)getAllBlockContact;

- (BOOL)blockContact:(CSContact *)contact;

- (BOOL)unblockContact:(CSContact *)contact;

- (BOOL)checkIfPhoneBlocked:(NSString *)phone;

@end
