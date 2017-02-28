//
//  CSCallHistoryManager.h
//  Contact Selector
//
//  Created by CPU11808 on 2/28/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSDatabaseManager.h"
#import "CSCall.h"

@interface CSCallHistoryManager : CSDatabaseManager

+ (instancetype)manager;

- (NSArray<CSCall *> *)getAllCalls;

- (BOOL)addCall:(CSCall *)call;

@end
