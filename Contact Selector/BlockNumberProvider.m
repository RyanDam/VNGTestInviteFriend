//
//  BlockNumberProvider.m
//  Contact Selector
//
//  Created by CPU11815 on 2/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "BlockNumberProvider.h"
#import "CSBlockDatebaseManager.h"

@implementation BlockNumberProvider

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> * data, NSError * err))completion {
    
    CSBlockDatebaseManager * manager = [CSBlockDatebaseManager manager];
    NSArray * data = [manager getAllBlockContact];
    if (data == nil) {
        data = @[];
    }
    completion(data, nil);
}

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion andQueue:(dispatch_queue_t)queue {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self getDataArrayWithCompletion:^(NSArray<CSModel *> *data, NSError *err) {
           
            if (queue) {
                dispatch_async(queue, ^{
                    completion(data, nil);
                });
            } else {
                completion(data, nil);
            }
        }];
    });
}

@end
