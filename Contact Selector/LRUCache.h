//
//  LRUCache.h
//  Contact Selector
//
//  Created by CPU11815 on 2/21/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRUCacheItem;

typedef void(^LRUHandlerCompleteBlock)(LRUCacheItem * item);

@interface LRUCache : NSObject

@property (nonatomic, readonly) NSUInteger maxSize;

+ (instancetype)getInstanceWithName:(NSString *)cacheName hopeSize:(NSUInteger)maxSize;

- (instancetype)initWithName:(NSString *)cacheName maxSize:(NSUInteger)maxSize;

- (void)addObject:(NSObject *)object forKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion;

- (void)addObject:(NSObject *)object forKey:(NSString *)key withSize:(NSUInteger)size withCompletion:(LRUHandlerCompleteBlock)completion;

- (void)objectForKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion;

- (void)removeObjectForKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion;

@end
