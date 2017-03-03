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

+ (id)instance;



- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> * data, NSError * err))completion andQueue:(dispatch_queue_t)queue;

@optional

- (void)getContactWithNumber:(NSString *)number withCompletion:(void (^)(CSModel *contact, NSError * err))completion;

@end
