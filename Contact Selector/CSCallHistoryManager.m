//
//  CSCallHistoryManager.m
//  Contact Selector
//
//  Created by CPU11808 on 2/28/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSCallHistoryManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"

#define CSCallTable @"CSCallTable"

typedef NS_ENUM(NSInteger, CSCallCollum) {
    CSCallCollumID,
    CSCallNumber,
    CSCallStartDate,
    CSCallEndDate
};

@implementation CSCallHistoryManager

+ (instancetype)manager {
    
    static CSCallHistoryManager * ret = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ret = [[CSCallHistoryManager alloc] init];
    });
    
    return ret;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        if (![self tableExistWithName:CSCallTable]) {
            NSDictionary * atts = @{@"number": @"varchar(255)", @"startDate": @"datetime", @"endDate":@"datetime"};
            [self createTableWithName:CSCallTable collumAttributes:atts];
        }
        return self;
    }
    return nil;
}

- (NSArray<CSCall *> *)getAllCalls {
    NSMutableArray *calls = [NSMutableArray new];
    
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@", CSCallTable];
    
    FMResultSet * result = [self.database executeQuery:query];
    
    while ([result next]) {
        NSString * phoneNumber = [result stringForColumnIndex:CSCallNumber];
        NSDate *start = [result dateForColumnIndex:CSCallStartDate];
        NSDate *end = [result dateForColumnIndex:CSCallEndDate];
        
        CSCall * call = [[CSCall alloc] init];
        call.number = phoneNumber;
        call.start = start;
        call.end = end;
        
        [calls addObject:call];
    }
    
    return calls;
}

- (BOOL)addCall:(CSCall *)call {

    BOOL ret = YES;
    
    ret = ret && [self.database executeUpdate:@"INSERT INTO CSCallTable (number, startDate, endDate) VALUES (?, ?, ?);", call.number, call.start, call.end];
    
    return ret;
}

@end
