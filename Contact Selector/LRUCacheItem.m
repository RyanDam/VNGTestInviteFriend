//
//  LRUCacheItem.m
//  Contact Selector
//
//  Created by CPU11815 on 2/21/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "LRUCacheItem.h"

@implementation LRUCacheItem

+ (void)readFromFilePath:(NSString *)path size:(NSUInteger)size withCompletion:(void (^)(LRUCacheItem *))completion {
    
    if (completion == nil) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData * data = [NSData dataWithContentsOfFile:path];
        if (data) {
            NSObject * item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            LRUCacheItem * result = [[LRUCacheItem alloc] init];
            result.value = item;
            result.size = size;
            completion(result);
        }
        completion(nil);
    });
}

- (instancetype)initWithObject:(NSObject *)object andSize:(NSUInteger)size {
    self = [super init];
    if (self) {
        self.value = object;
        self.size = size;
    }
    return self;
}

- (void)writeToFilePath:(NSString *)path withCompletion:(void (^)(LRUCacheItem *))completion {
    
    if (completion == nil) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSFileManager * manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:path]) {
            [manager removeItemAtPath:path error:nil];
        }
        
        [manager createFileAtPath:path contents:nil attributes:nil];
        
        if ([NSKeyedArchiver archiveRootObject:self.value toFile:path]) {
            completion(self);
        } else {
            completion(nil);
        }
    });
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.size] forKey:@"size"];
    [aCoder encodeObject:self.value forKey:@"value"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.value = [aDecoder decodeObjectForKey:@"value"];
        NSNumber * num = [aDecoder decodeObjectForKey:@"size"];
        self.size = num.unsignedIntegerValue;
    }
    return self;
}

@end
