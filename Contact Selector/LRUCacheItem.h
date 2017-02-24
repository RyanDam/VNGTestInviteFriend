//
//  LRUCacheItem.h
//  Contact Selector
//
//  Created by CPU11815 on 2/21/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRUCacheItem : NSObject <NSCoding>

@property (nonatomic) NSObject * value;
@property (nonatomic) NSUInteger size;

+ (void)readFromFilePath:(NSString *)path withCompletion:(void (^)(LRUCacheItem *))completion;

- (instancetype)initWithObject:(NSObject *)object andSize:(NSUInteger)size;

- (void)writeToFilePath:(NSString *)path withCompletion:(void (^)(LRUCacheItem *))completion;

@end
