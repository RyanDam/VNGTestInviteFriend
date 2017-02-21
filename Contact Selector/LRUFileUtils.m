//
//  LRUFileUtils.m
//  Contact Selector
//
//  Created by CPU11815 on 2/21/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "LRUFileUtils.h"

#define CACHE_PATH_NAME @"LRUCacheDisk"
#define CACHE_INFO_FILE @"cache.info"

@implementation LRUFileUtils

+ (NSString *)getAppPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return paths[0];
}

+ (NSString *)getCachePathWithCacheName:(NSString *)cacheName {
    
    NSString * appPath = [self getAppPath];
    return [[appPath stringByAppendingPathComponent:CACHE_PATH_NAME] stringByAppendingPathComponent:cacheName];
}

+ (NSString *)getCacheInfoFilePathWithCacheName:(NSString *)cacheName {
    
    NSString * cachePath = [self getCachePathWithCacheName:cacheName];
    return [cachePath stringByAppendingPathComponent:CACHE_INFO_FILE];
}

+ (NSString *)getFilePathForKey:(NSString *)key withCacheName:(NSString *)cacheName {
    
    NSString * cachePath = [self getCachePathWithCacheName:cacheName];
    return [cachePath stringByAppendingPathComponent:key];
}

@end
