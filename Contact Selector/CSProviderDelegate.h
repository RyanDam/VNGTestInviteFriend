//
//  CSProviderDelegate.h
//  Contact Selector
//
//  Created by Dam Vu Duy on 2/17/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * kCSProviderSearchKey;

@protocol CSProviderDelegate <NSObject>

- (NSArray *) getContactIndex;

- (NSDictionary *) getContactDictionary;

- (void)prepareForSearch;

- (void)performSearchText:(NSString *)text;

- (void)completeSearch;

@end
