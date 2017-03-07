//
//  CSDatabaseManager.m
//  Contact Selector
//
//  Created by Dam Vu Duy on 2/26/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSDatabaseManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"

@interface CSDatabaseManager()

@property (nonatomic) FMDatabase * internalDatabase;

@end

@implementation CSDatabaseManager

+ (instancetype)manager {
    
    static CSDatabaseManager * ret = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ret = [[CSDatabaseManager alloc] init];
    });
    
    return ret;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        NSFileManager * manager = [NSFileManager defaultManager];
        NSURL * url = [manager containerURLForSecurityApplicationGroupIdentifier:@"group.rstudio.Conact-Selector"];
        
        NSString * databasePath = [[url.absoluteString stringByAppendingPathComponent:@"MainDatabase"] stringByAppendingPathExtension:@"db"];
        
        NSLog(@"Database: %@", databasePath);
        
        self.internalDatabase = [FMDatabase databaseWithPath:databasePath];
        
        if (![self.internalDatabase open]) {
            return nil;
        }
        return self;
    }
    return nil;
}

- (FMDatabase *)database {
    
    return self.internalDatabase;
}

- (BOOL)tableExistWithName:(NSString *)name {
    
    NSString * query = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@';", name];
    FMResultSet * result = [self.internalDatabase executeQuery:query];
    
    while ([result next]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)createTableWithName:(NSString *)name collumAttributes:(NSDictionary *)attributes{
    
    NSString * tableAttributes = @"ID int AUTO INCREMENT";
    for (NSString * collum in [attributes allKeys]) {
        NSString * att = [attributes objectForKey:collum];
        tableAttributes = [NSString stringWithFormat:@"%@, %@ %@", tableAttributes, collum, att];
    }
    
    NSString * query = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)", name, tableAttributes];
    
    BOOL ret = [self.internalDatabase executeUpdate:query];
    
    return ret;
}

@end
