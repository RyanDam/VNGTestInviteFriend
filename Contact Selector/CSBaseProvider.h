//
//  CSBaseProvider.h
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * kCSProviderSearchKey;

@interface CSBaseProvider : NSObject

- (NSArray *) getContactIndex;

- (NSDictionary *) getContactDictionary;

- (void)prepareForSearch;

- (void)performSearchText:(NSString *)text;

- (void)completeSearch;

@end
