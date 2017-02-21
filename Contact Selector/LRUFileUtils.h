//
//  LRUFileUtils.h
//  Contact Selector
//
//  Created by CPU11815 on 2/21/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRUFileUtils : NSObject

+ (NSString *)getAppPath;

+ (NSString *)getCachePathWithCacheName:(NSString *)cacheName;

+ (NSString *)getCacheInfoFilePathWithCacheName:(NSString *)cacheName;

+ (NSString *)getFilePathForKey:(NSString *)key withCacheName:(NSString *)cacheName;

@end
