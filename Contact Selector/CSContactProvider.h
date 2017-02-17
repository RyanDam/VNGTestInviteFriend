//
//  CSContactProvider.h
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UIKit/UIKit.h"
#import "CSProviderDelegate.h"

@interface CSContactProvider : NSObject <CSProviderDelegate>

- (void)initDatabaseWithComplete:(void (^)(NSError * error))completion;

- (NSArray *) getContactIndex;

- (NSDictionary *) getContactDictionary;

- (void)prepareForSearch;

- (void)performSearchText:(NSString *)text withCompletion:(void (^)(CSSearchResult result))completion;

- (void)completeSearch;

@end
