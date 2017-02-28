//
//  CallObserver.h
//  Contact Selector
//
//  Created by CPU11815 on 2/28/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallObserver : NSObject

+ (instancetype)observer;

@property (nonatomic, copy) void (^refreshUI)(void);

@end
