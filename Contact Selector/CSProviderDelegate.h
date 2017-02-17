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

/**
 Init database, this method is need to called once first after create provider

 @param completion handler
 */
- (void)initDatabaseWithComplete:(void (^)(NSError * error))completion;

/**
 Return contact index character for scrollbar index

 @return array of index strings
 */
- (NSArray *) getContactIndex;

/**
 Return contact dictionary

 @return dictionary of contact
 */
- (NSDictionary *) getContactDictionary;

/**
 Prepare for search
 */
- (void)prepareForSearch;

/**
 Request filtered contact dictionary with given text

 @param text to search
 */
- (void)performSearchText:(NSString *)text;

/**
 User complete search
 */
- (void)completeSearch;

@end
