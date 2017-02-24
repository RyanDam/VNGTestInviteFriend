//
//  CSDataBusiness.h
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSModel.h"

extern NSString * kCSProviderSearchKey;

typedef NS_ENUM(NSInteger, CSContactListState) {
    CSContactListStateLoading,
    CSContactListStateNormal
};

typedef NS_ENUM(NSInteger, CSSearchResult) {
    CSSearchResultComplete,
    CSSearchResultNoResult
};

typedef void (^SearchCompleteBlock)(CSSearchResult searchResult, NSArray<NSString *> * index, NSDictionary<NSString *, NSArray<CSModel *> *> * dictionary) ;

typedef NSArray<NSString *> CSDataIndex;

typedef NSDictionary<NSString *, NSArray<CSModel *> *> CSDataDictionary;

typedef NSArray<CSModel *> CSDataArray;

@protocol CSDataBusiness <NSObject>

@required

- (CSDataIndex *)getDataIndexFromDataArray:(CSDataArray *) dataArray;

- (CSDataDictionary *)getDataDictionaryFromDataArray:(CSDataArray *) dataArray;

- (void)performSearch:(NSString *)text onDataArray:(CSDataArray *)dataArray withCompletion:(SearchCompleteBlock)completion;

@optional

- (void)prepareForSearch;

- (void)completeSearch;

@end
