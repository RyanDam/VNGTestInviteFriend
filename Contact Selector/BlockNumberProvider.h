//
//  BlockNumberProvider.h
//  Contact Selector
//
//  Created by CPU11815 on 2/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSDataProvider.h"


@interface BlockNumberProvider : NSObject <CSDataProvider>

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> * data, NSError * err))completion;

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion andCustomQueue:(dispatch_queue_t)queue;

@end
