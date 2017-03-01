//
//  CSContactBusiness.h
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSDataBusiness.h"

@interface CSContactBusiness : NSObject <CSDataBusiness>

@property (nonatomic) id<CSDataProvider> dataProvider;

- (instancetype)initWithProvider:(id<CSDataProvider>)provider;

- (id<CSDataProvider>)getDataProvider;

- (void)getDataIndexFromDataArray:(CSDataArray *) dataArray dispatchQueue:(dispatch_queue_t)queue withCompletion:(void (^)(CSDataIndex * index))completion;

- (void)getDataDictionaryFromDataArray:(CSDataArray *) dataArray dispatchQueue:(dispatch_queue_t)queue withCompletion:(void (^)(CSDataDictionary * dictionary))completion;

- (void)performSearch:(NSString *)text onDataArray:(CSDataArray *)dataArray dispatchQueue:(dispatch_queue_t)queue withCompletion:(SearchCompleteBlock)completion;

@end
