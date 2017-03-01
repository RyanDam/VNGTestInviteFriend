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

@property (nonatomic) NSString * cacheName;
@property (nonatomic, readonly) NSUInteger maxSize;

/**
 Get cacher with name

 @param cacheName Name of cacher
 @param maxSize max size wanted
 @return cacher instance
 */
+ (instancetype)getInstanceWithName:(NSString *)cacheName hopeSize:(NSUInteger)maxSize;

/**
 Create new cacher instance with cache name

 @param cacheName Name of cacher
 @param maxSize max size wanted
 @return cacher instance
 */
- (instancetype)initWithName:(NSString *)cacheName maxSize:(NSUInteger)maxSize;

/**
 Add new object to the cacher with key

 @param object object to cache
 @param key key of object
 @param completion handler
 */
- (void)addObject:(NSObject *)object forKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion;

/**
 Add new object to the cacher with key

 @param object object to cache
 @param key key of object
 @param size size of object
 @param completion handler
 */
- (void)addObject:(NSObject *)object forKey:(NSString *)key withSize:(NSUInteger)size withCompletion:(LRUHandlerCompleteBlock)completion;

/**
 Get object with specific key

 @param key key to get object
 @param completion handler
 */
- (void)objectForKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion;

/**
 Remove object with specific key

 @param key key to remove object
 @param completion handler
 */
- (void)removeObjectForKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion;

/**
 Remove all object of cacheer

 @param completion handler
 */
- (void)removeAllObjectWithCompletion:(LRUHandlerCompleteBlock)completion;

@end
