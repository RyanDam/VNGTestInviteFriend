//
//  CSBlockDatebaseManager.m
//  Contact Selector
//
//  Created by Dam Vu Duy on 2/26/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSBlockDatebaseManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"
#import "CSContact.h"

#define CSBlockTable @"CSBlockTable"

typedef NS_ENUM(NSInteger, CSBlockCollum) {
    CSBlockCollumID,
    CSBlockCollumContactName,
    CSBlockCollumPhoneNumber
};

@implementation CSBlockDatebaseManager

+ (instancetype)manager {
    
    static CSBlockDatebaseManager * ret = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ret = [[CSBlockDatebaseManager alloc] init];
    });
    
    return ret;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        if (![self tableExistWithName:CSBlockTable]) {
            NSDictionary * atts = @{@"name": @"varchar(255)", @"phoneNumber": @"varchar(255)"};
            [self createTableWithName:CSBlockTable collumAttributes:atts];
        }
        return self;
    }
    return nil;
}

- (NSArray<CSContact *> *)getAllBlockContact {
    
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@", CSBlockTable];
    
    FMResultSet * result = [self.database executeQuery:query];
    
    NSMutableArray<CSContact *> * ret = [NSMutableArray array];
    
    while ([result next]) {
        NSString * name = [result stringForColumnIndex:CSBlockCollumContactName];
        NSString * phoneNumber = [result stringForColumnIndex:CSBlockCollumPhoneNumber];
        
        CSContact * contact = [[CSContact alloc] init];
        contact.fullName = name;
        contact.phoneNumbers = @[phoneNumber];
        
        [ret addObject:contact];
    }
    
    return ret;
}

- (BOOL)blockContact:(CSContact *)contact {
    
    BOOL ret = YES;
    for (NSString * phone in contact.phoneNumbers) {
        NSString * query = [NSString stringWithFormat:@"INSERT INTO %@ (name, phoneNumber) VALUES ('%@','%@');", CSBlockTable, contact.fullName, phone];
        ret = ret && [self.database executeUpdate:query];
    }
    return ret;
}

- (BOOL)unblockContact:(CSContact *)contact {
    
    BOOL ret = YES;
    for (NSString * phone in contact.phoneNumbers) {
        NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE phoneNumber='%@';", CSBlockTable, phone];
        ret = ret && [self.database executeUpdate:query];
    }
    return ret;
}

@end
