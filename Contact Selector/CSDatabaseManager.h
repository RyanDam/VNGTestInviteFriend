//
//  CSDatabaseManager.h
//  Contact Selector
//
//  Created by Dam Vu Duy on 2/26/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface CSDatabaseManager : NSObject

@property (nonatomic, readonly) FMDatabase * database;

+ (instancetype)manager;

- (BOOL)tableExistWithName:(NSString *)name;

- (BOOL)createTableWithName:(NSString *)name collumAttributes:(NSDictionary *)attributes;

@end
