//
//  CSBaseProvider.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSBaseProvider.h"

NSString * kCSProviderSearchKey = @"SEARCH";

@implementation CSBaseProvider

- (NSArray *) getContactIndex {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override method: %@", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
    return nil;
}

- (NSDictionary *) getContactDictionary {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override method: %@", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
    return nil;
}

- (void)prepareForSearch {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override method: %@", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)performSearchText:(NSString *)text {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override method: %@", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)completeSearch {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override method: %@", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
