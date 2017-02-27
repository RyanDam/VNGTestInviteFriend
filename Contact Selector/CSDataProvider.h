//
//  CSDataProvider.h
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSModel.h"

@protocol CSDataProvider <NSObject>

@required

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> * data, NSError * err))completion;

@optional

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion andCustomQueue:(dispatch_queue_t)queue;

- (void)getNextPageDataWithCompletion:(void (^)(NSArray<CSModel *> *data, NSError *err))completion;

@end
