//
//  CSContactProvider.h
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSDataProvider.h"

@interface CSContactProvider : NSObject <CSDataProvider>

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> * data, NSError * err))completion;

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion andQueue:(dispatch_queue_t)queue;

@end
