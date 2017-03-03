//
//  CSDataBusiness.h
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSModel.h"
#import "CSDataProvider.h"

extern NSString * kCSProviderSearchKey;

typedef NSArray<NSString *> CSDataIndex;
typedef NSArray<CSModel *> CSDataArray;
typedef NSDictionary<NSString *, NSArray<CSModel *> *> CSDataDictionary;
typedef NS_ENUM(NSInteger, CSSearchResult) {
    CSSearchResultComplete,
    CSSearchResultNoResult
};
typedef void (^SearchCompleteBlock)(CSSearchResult searchResult, NSArray<NSString *> * index, NSDictionary<NSString *, NSArray<CSModel *> *> * dictionary);

@protocol CSDataBusiness <NSObject>

@required

+ (id)instance;

+ (id)instanceWithProvider:(id<CSDataProvider>)provider;

- (void)getDataIndexWithQueue:(dispatch_queue_t)queue withCompletion:(void (^)(CSDataIndex * index))completion;

- (void)getDataDictionaryWithQueue:(dispatch_queue_t)queue withCompletion:(void (^)(CSDataDictionary * dictionary))completion;

- (void)performSearch:(NSString *)text dispatchQueue:(dispatch_queue_t)queue withCompletion:(SearchCompleteBlock)completion;

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> * data, NSError * err))completion;

@optional

- (void)prepareForSearch;

- (void)completeSearch;


@end
